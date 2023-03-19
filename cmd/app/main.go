package main

import (
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/takokun778/goapptemplate/pkg/log"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		ctx := log.SetLogCtx(r.Context())

		log.GetLogCtx(ctx).Info(fmt.Sprintf("[%s] %s", r.Method, r.URL))

		_, _ = w.Write([]byte(Hello("Golang")))
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte("OK"))
	})

	log.Log().Info("starting server...")

	const timeout = 3

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	server := &http.Server{
		Addr:              fmt.Sprintf(":%s", port),
		ReadHeaderTimeout: timeout * time.Second,
	}

	log.Log().Info(fmt.Sprintf("listening on %s", server.Addr))

	if err := server.ListenAndServe(); err != nil {
		log.Log().Fatal("failed to listen and serve", log.ErrorField(err))
	}
}

func Hello(name string) string {
	return fmt.Sprintf("Hello, %s!", name)
}
