package e2e_test

import (
	"net/http"
	"os"
	"testing"
)

func TestE2E(t *testing.T) {
	t.Parallel()

	tests := []struct {
		name string
	}{
		{
			name: "success",
		},
	}

	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			res, err := http.Get(os.Getenv("E2E_ENDPOINT")) //nolint:noctx
			if err != nil {
				t.Errorf("http.Get() error = %v", err)
			}
			if res.StatusCode != http.StatusOK {
				t.Errorf("http.Get() status = %v", res.StatusCode)
			}

			defer res.Body.Close()
		})
	}
}
