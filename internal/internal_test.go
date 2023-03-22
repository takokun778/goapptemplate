package internal_test

import "testing"

func TestInternal(t *testing.T) {
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
		})
	}
}
