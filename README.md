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

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/aaronbatchelder/protoflow/main/install.sh | bash
```

Requires [Claude Code](https://claude.ai/code):

```bash
npm install -g @anthropic-ai/claude-code
claude  # Follow prompts to log in
```

## Quick Start

```bash
cd ~/your-project
protoflow
```

## Usage

### In an Existing Project

```bash
cd ~/projects/myapp
protoflow
# Press Enter to use current directory, then follow prompts
```

### Start a New Project

```bash
protoflow
# Enter a project name like "my-app" (creates ~/projects/my-app)
# Or enter a full path like ~/code/new-project
```

### Non-Interactive Mode

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
2. **Assigns unique dev server ports** - Approach A gets port 4000, B gets 4001, etc. to avoid conflicts
3. **Spawns Claude Code agents** - Opens a separate terminal window for each approach
4. **Auto-injects the prompt** - Each agent starts working immediately with the task + its specific constraint
5. **You watch and compare** - Switch between windows to see approaches develop in real-time

## Window Navigation

Each approach runs in its own terminal window:

| Shortcut | Action |
|----------|--------|
| `Cmd+\`` (macOS) | Switch between terminal windows |
| `Alt+Tab` (Linux) | Switch between terminal windows |

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

### Both approaches trying to use the same port
ProtoFlow automatically assigns different ports to each approach (A=4000, B=4001, C=4002, D=4003). This is included in the PROMPT.md for each approach.

### Terminal windows not opening (Linux)
ProtoFlow tries gnome-terminal, konsole, and xterm in order. If none are available, you'll need to manually run Claude in each worktree directory.

## License

MIT

## Contributing

PRs welcome! Some ideas:
- [ ] Add a comparison view after approaches complete
- [ ] Support for more than 4 approaches
- [ ] Web UI for monitoring progress
- [ ] Auto-detect when approaches are complete
- [ ] Cost tracking per approach
