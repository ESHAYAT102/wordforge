package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	url := flag.String("u", "", "URL to crawl")
	output := flag.String("o", "passwords.txt", "final output file")
	top := flag.Int("t", 10, "number of top words")
	flag.Usage = func() { fmt.Fprintln(os.Stderr, "Usage: wordforge -u URL [-t N] [-o OUTPUT]") }
	flag.Parse()
	if *url == "" || *top <= 0 {
		flag.Usage()
		os.Exit(2)
	}

	rawWords := filepath.Join(".", "words.txt")
	topWords := filepath.Join(".", "top.txt")

	step("crawling page")
	run("crwl", "-u", *url, "-o", rawWords)
	step("selecting top words")
	run("lapip", "-t", fmt.Sprint(*top), "-o", topWords, rawWords)
	step("generating password combinations")
	run("crack", "-i", topWords, "-o", *output)
	fmt.Printf("wrote passwords to %s\n", *output)
}

func run(name string, args ...string) {
	tool, err := resolveTool(name)
	if err != nil {
		fail(err)
	}
	cmd := exec.Command(tool, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		fail(fmt.Errorf("%s: %w", name, err))
	}
}

func resolveTool(name string) (string, error) {
	if path, err := exec.LookPath(name); err == nil {
		return path, nil
	}
	wd, err := os.Getwd()
	if err != nil {
		return "", err
	}
	candidates := []string{
		filepath.Join(wd, name),
		filepath.Join(wd, "..", name, name),
		filepath.Join(wd, "..", name),
	}
	for _, candidate := range candidates {
		if info, err := os.Stat(candidate); err == nil && !info.IsDir() && info.Mode()&0o111 != 0 {
			return candidate, nil
		}
	}
	return "", fmt.Errorf("could not find %s; add it to PATH or build it beside the project", name)
}

func step(message string) { fmt.Println(message + "...") }

func fail(err error) {
	fmt.Fprintln(os.Stderr, "error:", err)
	os.Exit(1)
}
