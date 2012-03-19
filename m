Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2CSPxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:53:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57775 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab2CSPxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:53:46 -0400
Date: Mon, 19 Mar 2012 16:53:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events changes for v3.4
Message-ID: <20120319155342.GA5113@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

   HEAD: bea95c152dee1791dd02cbc708afbb115bb00f9a Merge branch 'perf/hw-branch-sampling' into perf/core

 Thanks,

	Ingo

------------------>
Akihiro Nagai (4):
      perf script: Unify the expressions indicating "unknown"
      perf script: Print branch_from and branch_to of BTS events
      perf script: Add the offset field specifier
      perf script: Add option resolving vmlinux path

Andrey Vagin (1):
      tracing: Don't print an extra separator of flags

Arnaldo Carvalho de Melo (5):
      perf tools: Add fprintf methods for thread_map and cpu_map classes
      perf tools: Introduce per user view
      perf python: Use attr.watermark in twatch.py
      perf tools: Handle kernels that don't support attr.exclude_{guest,host}
      perf tools: Invert the sample_id_all logic

Borislav Petkov (1):
      x86/sched/perf/AMD: Set sched_clock_stable

Danny Kukawka (1):
      perf tools: Remove duplicated string.h includes

David Ahern (3):
      perf record: No build id option fails
      perf tools: Fix out of tree compiles
      perf tools: Allow multiple threads or processes in record, stat, top

David Daney (1):
      perf tools: Fix broken build by defining _GNU_SOURCE in Makefile

David Smith (1):
      tracepoint, vfs, sched: Add exec() tracepoint

Fernando Luis Vázquez Cao (3):
      watchdog: Update documentation
      watchdog: Update Kconfig entries
      watchdog: Fix code/comments mismatches

Franck Bui-Huu (1):
      perf doc: Allow producing documentation in a specified output directory

Geunsik Lim (2):
      ftrace: sched_switch plugin is deprecated
      ftrace: Append wakeup_rt description of ftrace doc

Ingo Molnar (1):
      static keys: Introduce 'struct static_key', static_key_true()/false() and static_key_slow_[inc|dec]()

Jan Beulich (4):
      perf bench: Make "default" memcpy() selection actually use glibc's implementation
      perf bench: Also allow measuring alternative memcpy implementations
      perf bench: Also allow measuring memset()
      perf bench: Allow passing an iteration count to "bench mem mem{cpy,set}"

Jason Baron (4):
      jump label: Add a WARN() if jump label key count goes negative
      jump label: Fix compiler warning
      static keys: Add docs better explaining the whole 'struct static_key' mechanism
      static keys: Inline the static_key_enabled() function

Jiri Olsa (13):
      perf evlist: Make splice_list_tail method public
      ftrace: Change filter/notrace set functions to return exit code
      perf tool: Fix perf stack to non executable on x86_64
      perf tools: Remove unused functions from debugfs object
      perf tools: Add sysfs mountpoint interface
      perf tools: Add bitmap_or function into bitmap object
      ftrace: Add enable/disable ftrace_ops control interface
      ftrace, perf: Add open/close tracepoint perf registration actions
      ftrace, perf: Add add/del tracepoint perf registration actions
      ftrace: Add FTRACE_ENTRY_REG macro to allow event registration
      ftrace, perf: Add support to use function tracepoint in perf
      ftrace: Allow to specify filter field type for ftrace events
      ftrace, perf: Add filter support for function trace event

Joerg Roedel (2):
      perf top: Don't process samples with no valid machine object
      perf tools: Change perf_guest default back to false

Johannes Berg (1):
      printk/tracing: Add console output tracing

John Kacur (1):
      perf tools: Remove distclean from Makefile help output

Masami Hiramatsu (4):
      x86: Fix to decode grouped AVX with VEX pp bits
      x86/kprobes: Fix instruction recovery on optimized path
      x86/kprobes: Fix a bug which can modify kernel code permanently
      x86/kprobes: Split out optprobe related code to kprobes-opt.c

Masanari Iida (1):
      perf evsel: Fix spelling typo

Namhyung Kim (15):
      perf lock: Document lock info subcommand
      perf tools: Remove unnecessary ctype.h inclusion
      perf stat: Adjust print unit
      perf stat: Align scaled output of cpu-clock
      perf tools: Fix build dependency of perf python extension
      perf tools: Implement islower/isupper macro into util.h
      perf tools: ctype.c only wants util.h
      perf tools: Get rid of ctype.h in symbol.c
      perf evlist: Restore original errno after open failed
      perf tools: Add descriptions of missing Makefile arguments
      perf annotate: Print asm code as blue when source code is displayed
      perf annotate: Handle lower case key code in annotate_browser__run()
      perf annotate: Restore title when came back to original symbol
      perf annotate: Fix help string on tui
      perf annotate: Add missing newline on error message

Oleg Nesterov (2):
      tracing: let trace_signal_generate() report more info, kill overflow_fail/lose_info
      tracing: send_sigqueue() needs trace_signal_generate() too

Peter Zijlstra (9):
      perf: Update the mmap control page on mmap()
      perf, arch: Rework perf_event_index()
      perf: Fix mmap_page::offset computation
      perf, x86: Implement user-space RDPMC support, to allow fast, user-space access to self-monitoring counters
      perf, x86: Provide means for disabling userspace RDPMC
      perf: Extend the mmap control page with time (TSC) fields
      perf tools: Add x86 RDPMC, RDTSC test
      jump_label: Add some documentation
      perf/x86: Prettify pmu config literals

Robert Richter (3):
      perf record: Make feature initialization generic
      perf tools: Moving code in header.c
      perf tools: Factor out feature op to process header sections

Roberto Agostino Vitillo (3):
      perf tools: Add code to support PERF_SAMPLE_BRANCH_STACK
      perf record: Add support for sampling taken branch
      perf report: Add support for taken branch sampling

Srikar Dronamraju (2):
      perf probe: Usability fixes
      perf probe: Rename target_module to target

Stefan Hajnoczi (1):
      perf tools: Allow expressions in __print_symbolic() fields

Stephane Eranian (25):
      perf tools: Fix strlen() bug in perf_event__synthesize_event_type()
      perf top: Fix number of samples displayed
      perf tools: fix endianness detection in perf.data
      perf tools: cleanup initialization of attr->size
      perf tools: fix broken perf record -a mode
      perf: Add generic taken branch sampling support
      perf/x86: Add Intel LBR MSR definitions
      perf/x86: Add Intel LBR sharing logic
      perf/x86: Sync branch stack sampling with precise_sampling
      perf/x86: Add Intel LBR mappings for PERF_SAMPLE_BRANCH filters
      perf/x86: Disable LBR support for older Intel Atom processors
      perf/x86: Implement PERF_SAMPLE_BRANCH for Intel CPUs
      perf/x86: Add LBR software filter support for Intel CPUs
      perf: Disable PERF_SAMPLE_BRANCH_* when not supported
      perf: Add callback to flush branch_stack on context switch
      perf: Add ABI reference sizes
      perf tools: Enable reading of perf.data files from different ABI rev
      perf tools: Fix ABI compatibility bug in print_event_desc()
      perf tools: Make perf able to read files from older ABIs
      perf record: Provide default branch stack sampling mode option
      perf record: Add HEADER_BRANCH_STACK tag
      perf report: Auto-detect branch stack sampling mode
      perf report: Enable TUI in branch view mode
      perf report: Remove duplicate annotate choice in branch view mode
      perf report: Fix annotate double quit issue in branch view mode

Steven Rostedt (5):
      tracing/softirq: Move __raise_softirq_irqoff() out of header
      tracing/rcu: Add trace_##name##__rcuidle() static tracepoint for inside rcu_idle_exit() sections
      x86/tracing: Denote the power and cpuidle tracepoints as _rcuidle()
      cpuidle/tracing: Denote the tracepoints as being in rcu_idle_exit() section
      tracing: Don't use p->len field to determine output in __print_*() functions

Thomas Meyer (1):
      tracing/trivial: Use kcalloc instead of kzalloc to allocate array


 Documentation/lockup-watchdogs.txt                 |   63 ++
 Documentation/nmi_watchdog.txt                     |   83 ---
 Documentation/static-keys.txt                      |  286 +++++++++
 Documentation/trace/ftrace.txt                     |    7 +
 arch/Kconfig                                       |   29 +-
 arch/alpha/kernel/perf_event.c                     |    4 +
 arch/arm/include/asm/perf_event.h                  |    4 -
 arch/arm/kernel/perf_event.c                       |    4 +
 arch/frv/include/asm/perf_event.h                  |    2 -
 arch/hexagon/include/asm/perf_event.h              |    2 -
 arch/ia64/include/asm/paravirt.h                   |    6 +-
 arch/ia64/kernel/paravirt.c                        |    4 +-
 arch/mips/include/asm/jump_label.h                 |    2 +-
 arch/mips/kernel/perf_event_mipsxx.c               |    4 +
 arch/powerpc/include/asm/jump_label.h              |    2 +-
 arch/powerpc/include/asm/perf_event_server.h       |    2 -
 arch/powerpc/kernel/perf_event.c                   |   10 +
 arch/s390/include/asm/jump_label.h                 |    2 +-
 arch/s390/include/asm/perf_event.h                 |    1 -
 arch/sh/kernel/perf_event.c                        |    4 +
 arch/sparc/include/asm/jump_label.h                |    2 +-
 arch/sparc/kernel/perf_event.c                     |    4 +
 arch/x86/include/asm/inat.h                        |    5 +-
 arch/x86/include/asm/insn.h                        |   18 +-
 arch/x86/include/asm/jump_label.h                  |    6 +-
 arch/x86/include/asm/msr-index.h                   |    7 +
 arch/x86/include/asm/paravirt.h                    |    6 +-
 arch/x86/include/asm/perf_event.h                  |    2 -
 arch/x86/kernel/Makefile                           |    1 +
 arch/x86/kernel/cpu/amd.c                          |    3 +
 arch/x86/kernel/cpu/perf_event.c                   |  167 +++++-
 arch/x86/kernel/cpu/perf_event.h                   |   50 ++
 arch/x86/kernel/cpu/perf_event_amd.c               |    3 +
 arch/x86/kernel/cpu/perf_event_intel.c             |  141 ++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |   22 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |  526 +++++++++++++++-
 arch/x86/kernel/kprobes-common.h                   |  102 +++
 arch/x86/kernel/kprobes-opt.c                      |  512 +++++++++++++++
 arch/x86/kernel/kprobes.c                          |  664 +++-----------------
 arch/x86/kernel/kvm.c                              |    4 +-
 arch/x86/kernel/paravirt.c                         |    4 +-
 arch/x86/kernel/process.c                          |   24 +-
 arch/x86/kvm/mmu_audit.c                           |    8 +-
 arch/x86/lib/inat.c                                |   36 +-
 arch/x86/lib/insn.c                                |   13 +-
 drivers/cpuidle/cpuidle.c                          |    8 +-
 fs/exec.c                                          |    9 +-
 include/linux/ftrace.h                             |   77 +++-
 include/linux/ftrace_event.h                       |    9 +-
 include/linux/interrupt.h                          |    7 +-
 include/linux/jump_label.h                         |  162 ++++-
 include/linux/netdevice.h                          |    4 +-
 include/linux/netfilter.h                          |    6 +-
 include/linux/perf_event.h                         |  108 +++-
 include/linux/static_key.h                         |    1 +
 include/linux/tracepoint.h                         |   28 +-
 include/net/sock.h                                 |    6 +-
 include/trace/events/power.h                       |    2 +
 include/trace/events/printk.h                      |   41 ++
 include/trace/events/sched.h                       |   27 +
 include/trace/events/signal.h                      |   85 +--
 kernel/events/core.c                               |  246 +++++++-
 kernel/events/hw_breakpoint.c                      |   13 +
 kernel/irq/chip.c                                  |    2 +
 kernel/jump_label.c                                |  135 +++--
 kernel/printk.c                                    |    5 +
 kernel/sched/core.c                                |   18 +-
 kernel/sched/fair.c                                |    8 +-
 kernel/sched/sched.h                               |   14 +-
 kernel/signal.c                                    |   28 +-
 kernel/softirq.c                                   |    6 +
 kernel/trace/ftrace.c                              |  134 ++++-
 kernel/trace/trace.c                               |    6 +-
 kernel/trace/trace.h                               |   38 +-
 kernel/trace/trace_entries.h                       |   54 ++-
 kernel/trace/trace_event_perf.c                    |  208 +++++--
 kernel/trace/trace_events.c                        |   12 +-
 kernel/trace/trace_events_filter.c                 |  175 +++++-
 kernel/trace/trace_export.c                        |   64 ++-
 kernel/trace/trace_kprobe.c                        |    8 +-
 kernel/trace/trace_output.c                        |   12 +-
 kernel/trace/trace_syscalls.c                      |   22 +-
 kernel/tracepoint.c                                |   20 +-
 kernel/watchdog.c                                  |   24 +-
 lib/Kconfig.debug                                  |   18 +-
 net/core/dev.c                                     |   24 +-
 net/core/net-sysfs.c                               |    4 +-
 net/core/sock.c                                    |    4 +-
 net/core/sysctl_net_core.c                         |    4 +-
 net/ipv4/tcp_memcontrol.c                          |    6 +-
 net/netfilter/core.c                               |    6 +-
 tools/perf/Documentation/Makefile                  |   86 ++-
 tools/perf/Documentation/perf-lock.txt             |   20 +-
 tools/perf/Documentation/perf-record.txt           |   38 ++-
 tools/perf/Documentation/perf-report.txt           |   10 +
 tools/perf/Documentation/perf-script.txt           |    5 +-
 tools/perf/Documentation/perf-stat.txt             |    4 +-
 tools/perf/Documentation/perf-top.txt              |    8 +-
 tools/perf/MANIFEST                                |    1 +
 tools/perf/Makefile                                |   26 +-
 tools/perf/bench/bench.h                           |    1 +
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h       |    8 +
 tools/perf/bench/mem-memcpy-x86-64-asm.S           |    6 +-
 tools/perf/bench/mem-memcpy.c                      |   12 +-
 tools/perf/bench/mem-memset-arch.h                 |   12 +
 tools/perf/bench/mem-memset-x86-64-asm-def.h       |   12 +
 tools/perf/bench/mem-memset-x86-64-asm.S           |   13 +
 tools/perf/bench/mem-memset.c                      |  297 +++++++++
 tools/perf/builtin-bench.c                         |    3 +
 tools/perf/builtin-lock.c                          |    4 +-
 tools/perf/builtin-probe.c                         |   12 +-
 tools/perf/builtin-record.c                        |  152 ++++-
 tools/perf/builtin-report.c                        |  178 +++++-
 tools/perf/builtin-script.c                        |   80 ++-
 tools/perf/builtin-stat.c                          |   41 +-
 tools/perf/builtin-test.c                          |  188 ++++++-
 tools/perf/builtin-top.c                           |   45 +-
 tools/perf/perf.h                                  |   26 +-
 tools/perf/python/twatch.py                        |    2 +-
 tools/perf/util/annotate.c                         |    2 +-
 tools/perf/util/bitmap.c                           |   10 +
 tools/perf/util/cpumap.c                           |   11 +
 tools/perf/util/cpumap.h                           |    4 +
 tools/perf/util/ctype.c                            |    2 +-
 tools/perf/util/debugfs.c                          |  141 -----
 tools/perf/util/debugfs.h                          |    6 -
 tools/perf/util/event.h                            |    1 +
 tools/perf/util/evlist.c                           |   17 +-
 tools/perf/util/evlist.h                           |    9 +-
 tools/perf/util/evsel.c                            |   22 +-
 tools/perf/util/header.c                           |  588 ++++++++++++------
 tools/perf/util/header.h                           |    3 +-
 tools/perf/util/hist.c                             |  122 +++-
 tools/perf/util/hist.h                             |   13 +
 tools/perf/util/include/asm/dwarf2.h               |    4 +-
 tools/perf/util/include/linux/bitmap.h             |   11 +
 tools/perf/util/map.c                              |   15 +
 tools/perf/util/map.h                              |    1 +
 tools/perf/util/probe-event.c                      |   33 +-
 tools/perf/util/probe-finder.c                     |    1 -
 tools/perf/util/python-ext-sources                 |   19 +
 tools/perf/util/python.c                           |   10 +-
 .../util/scripting-engines/trace-event-python.c    |    1 -
 tools/perf/util/session.c                          |  126 +++-
 tools/perf/util/session.h                          |    6 +-
 tools/perf/util/setup.py                           |    8 +-
 tools/perf/util/sort.c                             |  287 +++++++--
 tools/perf/util/sort.h                             |   11 +
 tools/perf/util/symbol.c                           |   24 +-
 tools/perf/util/symbol.h                           |   24 +-
 tools/perf/util/sysfs.c                            |   60 ++
 tools/perf/util/sysfs.h                            |    6 +
 tools/perf/util/thread_map.c                       |  237 +++++++-
 tools/perf/util/thread_map.h                       |   11 +-
 tools/perf/util/top.c                              |   13 +-
 tools/perf/util/top.h                              |    6 +-
 tools/perf/util/trace-event-parse.c                |   13 +-
 tools/perf/util/trace-event-read.c                 |    1 -
 tools/perf/util/trace-event-scripting.c            |    1 -
 tools/perf/util/ui/browsers/annotate.c             |   18 +-
 tools/perf/util/ui/browsers/hists.c                |  105 +++-
 tools/perf/util/ui/browsers/map.c                  |    2 +-
 tools/perf/util/usage.c                            |   39 ++
 tools/perf/util/util.c                             |    2 +
 tools/perf/util/util.h                             |    6 +
 165 files changed, 6107 insertions(+), 1984 deletions(-)
 create mode 100644 Documentation/lockup-watchdogs.txt
 delete mode 100644 Documentation/nmi_watchdog.txt
 create mode 100644 Documentation/static-keys.txt
 create mode 100644 arch/x86/kernel/kprobes-common.h
 create mode 100644 arch/x86/kernel/kprobes-opt.c
 create mode 100644 include/linux/static_key.h
 create mode 100644 include/trace/events/printk.h
 create mode 100644 tools/perf/bench/mem-memset-arch.h
 create mode 100644 tools/perf/bench/mem-memset-x86-64-asm-def.h
 create mode 100644 tools/perf/bench/mem-memset-x86-64-asm.S
 create mode 100644 tools/perf/bench/mem-memset.c
 create mode 100644 tools/perf/util/python-ext-sources
 create mode 100644 tools/perf/util/sysfs.c
 create mode 100644 tools/perf/util/sysfs.h

[ combo diff too big ]
