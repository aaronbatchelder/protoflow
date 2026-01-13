# ProtoFlow

Prototype multiple approaches in parallel. Merge the best one.

ProtoFlow lets you define a task once, then spawn multiple [Claude Code](https://claude.ai/code) agents - each with different constraints or approaches defined by you. Watch them build side-by-side and pick the winner.

![ProtoFlow Demo](https://github.com/aaronbatchelder/ProtoFlow/blob/main/protoflow.gif)

## Why?

When building a feature, there's often multiple valid approaches:
- Redux vs Context vs Zustand for state management
- REST vs GraphQL for an API
- Tailwind vs CSS-in-JS for styling

Instead of wasting time deciding, **prototype them all**. Let multiple concurrent agents build each approach simultaneously, then compare real working code and experiences.

## Prerequisites

### 1. Claude Code CLI

ProtoFlow requires [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Anthropic's AI coding assistant.

**Install Claude Code:**
```bash
npm install -g @anthropic-ai/claude-code
```

**Authenticate:**
```bash
claude
# Follow the prompts to log in with your Anthropic account
```

You'll need an Anthropic account with API access. Visit [console.anthropic.com](https://console.anthropic.com) to sign up.

### 2. tmux

ProtoFlow uses tmux to run multiple Claude agents side-by-side.

```bash
# macOS
brew install tmux

# Ubuntu/Debian
sudo apt install tmux

# Fedora
sudo dnf install tmux
```

### 3. Git

Git is required for creating isolated worktrees for each approach.

```bash
# macOS
brew install git

# Ubuntu/Debian
sudo apt install git
```

## Installation

```bash
# Clone the repo
git clone https://github.com/yourusername/protoflow.git
cd protoflow

# Make it executable
chmod +x protoflow

# Symlink to your PATH (optional, for global access)
ln -s $(pwd)/protoflow /usr/local/bin/protoflow
```

## Usage

### Interactive Mode (Recommended)

Just run:

```bash
protoflow
```

You'll be guided through:
1. **Project** - Enter a path or just a name (e.g., `my-app` creates `~/projects/my-app`)
2. **Task** - Describe what you want to build
3. **Approaches** - Define 2-4 different approaches to explore

### CLI Mode

```bash
protoflow "Add user authentication" \
  --repo ~/projects/myapp \
  --approach "Use Passport.js with sessions" \
  --approach "Use JWT tokens"
```

### Options

| Option | Description |
|--------|-------------|
| `--repo`, `-r` | Path to git repository |
| `--approach`, `-a` | Constraint for an approach (use multiple times) |
| `--help`, `-h` | Show help message |

## How It Works

1. **Creates isolated git worktrees** - Each approach gets its own branch and working directory
2. **Assigns unique dev server ports** - Approach A gets port 3000, B gets 3001, etc. to avoid conflicts
3. **Spawns Claude Code agents** - Opens tmux with side-by-side panes, each running Claude
4. **Auto-injects the prompt** - Each agent starts working immediately with the task + its specific constraint
5. **You watch and compare** - See both approaches develop in real-time

```
┌─────────────────────────────────┬─────────────────────────────────┐
│ Approach A: Redux               │ Approach B: Zustand             │
│                                 │                                 │
│ Claude is implementing...       │ Claude is implementing...       │
│ > Creating store/index.ts       │ > Creating store.ts             │
│ > Adding userSlice.ts           │ > Simple 15 lines of code       │
│ > Configuring middleware...     │ > Done!                         │
│                                 │                                 │
└─────────────────────────────────┴─────────────────────────────────┘
```

## Keyboard Shortcuts

While in the tmux session:

| Shortcut | Action |
|----------|--------|
| `Ctrl+B` then `o` | Switch between panes |
| `Ctrl+B` then `→` | Move to right pane |
| `Ctrl+B` then `←` | Move to left pane |
| `Ctrl+B` then `D` | Detach (keeps running in background) |
| `Ctrl+B` then `z` | Zoom current pane (toggle fullscreen) |

To reattach to a detached session:
```bash
tmux attach -t protoflow-<id>
```

## Example Use Cases

### State Management Showdown
```bash
protoflow "Add a shopping cart with add/remove/update quantity" \
  --repo ~/projects/ecommerce \
  --approach "Use Redux Toolkit" \
  --approach "Use Zustand" \
  --approach "Use React Context + useReducer"
```

### API Design Battle
```bash
protoflow "Create a blog API with posts, comments, and users" \
  --repo ~/projects/blog-api \
  --approach "REST with Express" \
  --approach "GraphQL with Apollo Server"
```

### Styling Strategies
```bash
protoflow "Build a responsive dashboard layout" \
  --repo ~/projects/dashboard \
  --approach "Use Tailwind CSS" \
  --approach "Use styled-components"
```

### Database Decisions
```bash
protoflow "Implement user data persistence" \
  --repo ~/projects/app \
  --approach "Use PostgreSQL with Prisma" \
  --approach "Use MongoDB with Mongoose"
```

## After the Session

Each approach lives on its own git branch:
```
protoflow/<timestamp>/approach-a
protoflow/<timestamp>/approach-b
```

To merge the winning approach:
```bash
cd ~/projects/myapp
git merge protoflow/20240115-143022/approach-b
```

To clean up branches:
```bash
git branch -D protoflow/20240115-143022/approach-a protoflow/20240115-143022/approach-b
```

## Configuration

Session data is stored in `~/.protoflow/sessions/`. Each session creates:
- Git worktrees for isolated development
- `PROMPT.md` files with the task and approach constraints

## Troubleshooting

### "tmux is required but not installed"
```bash
brew install tmux  # macOS
sudo apt install tmux  # Ubuntu/Debian
```

### "Not a git repository"
ProtoFlow needs a git repo to create worktrees. Run `git init` first or let ProtoFlow create one for you in interactive mode.

### Claude isn't installed
```bash
npm install -g @anthropic-ai/claude-code
```

### Claude isn't authenticated
Run `claude` by itself and follow the login prompts:
```bash
claude
# Opens browser to authenticate with your Anthropic account
```

You need an Anthropic account with API access. Sign up at [console.anthropic.com](https://console.anthropic.com).

### Claude shows "bypass permissions" warning
This is expected. ProtoFlow runs Claude with `--dangerously-skip-permissions` so it can work autonomously. The script automatically accepts this warning.

### Both approaches trying to use the same port
ProtoFlow automatically assigns different ports to each approach (A=3000, B=3001, C=3002, D=3003). This is included in the PROMPT.md for each approach.

### Panes are too small
Press `Ctrl+B` then `z` to zoom the current pane to fullscreen. Press again to unzoom.

## License

MIT

## Contributing

PRs welcome! Some ideas:
- [ ] Add a comparison view after approaches complete
- [ ] Support for more than 4 approaches
- [ ] Web UI for monitoring progress
- [ ] Auto-detect when approaches are complete
- [ ] Cost tracking per approach
