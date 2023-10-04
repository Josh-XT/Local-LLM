#!/bin/sh

set -e

MODEL_URL=${MODEL_URL:-"TheBloke/Mistral-7B-OpenOrca-GGUF"}
MODEL_PATH=$(python3 GetModel.py --model_url $MODEL_URL)
MAX_TOKENS=${MAX_TOKENS:-8192}
THREADS=${THREADS:-($(nproc) - 1)}
THREADS_BATCH=${THREADS_BATCH:-$THREADS}
GPU_LAYERS=${GPU_LAYERS:-0}
MAIN_GPU=${MAIN_GPU:-0}
BATCH_SIZE=${BATCH_SIZE:-512}

# Workers should be threads divide by threads_batch rounded up to the nearest whole number
UVICORN_WORKERS=$(python3 -c "from math import ceil; print(ceil($THREADS / $THREADS_BATCH))")
make
uvicorn app:app --host 0.0.0.0 --port 8091 --workers $UVICORN_WORKERS --proxy-headers