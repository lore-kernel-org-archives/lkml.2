Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2JSAQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:16:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39068 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2JSAQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:16:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6869"; a="312600"
Date: Thu, 18 Oct 2012 19:16:19 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [GIT PULL] Please pull the Hexagon branch
Message-ID: <20121019001619.GA24832@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following small changes for the Hexagon arch.  It includes
the Hexagon UAPI changes from David Howells and some CR marking changes for
the transition from Code Aurora to Linux Foundation.


Thanks,
Richard Kuo



The following changes since commit 32bec973a8435afc0b032da22174701f836549b2:

  crypto: aesni - fix XTS mode on x86-32, add wrapper function for asmlinkage aesni_enc() (2012-10-18 14:01:33 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.git for-linus

David Howells (1):
      UAPI: (Scripted) Disintegrate arch/hexagon/include/asm

Richard Kuo (1):
      Hexagon: Copyright marking changes

 arch/hexagon/include/asm/Kbuild                   |    3 -
 arch/hexagon/include/asm/atomic.h                 |    2 +-
 arch/hexagon/include/asm/barrier.h                |    2 +-
 arch/hexagon/include/asm/bitops.h                 |    2 +-
 arch/hexagon/include/asm/cache.h                  |    2 +-
 arch/hexagon/include/asm/cacheflush.h             |    2 +-
 arch/hexagon/include/asm/checksum.h               |    2 +-
 arch/hexagon/include/asm/cmpxchg.h                |    2 +-
 arch/hexagon/include/asm/delay.h                  |    2 +-
 arch/hexagon/include/asm/dma-mapping.h            |    2 +-
 arch/hexagon/include/asm/dma.h                    |    2 +-
 arch/hexagon/include/asm/elf.h                    |    2 +-
 arch/hexagon/include/asm/exec.h                   |    2 +-
 arch/hexagon/include/asm/fixmap.h                 |    2 +-
 arch/hexagon/include/asm/hexagon_vm.h             |    2 +-
 arch/hexagon/include/asm/intrinsics.h             |    2 +-
 arch/hexagon/include/asm/io.h                     |    2 +-
 arch/hexagon/include/asm/irq.h                    |    2 +-
 arch/hexagon/include/asm/irqflags.h               |    2 +-
 arch/hexagon/include/asm/kgdb.h                   |    2 +-
 arch/hexagon/include/asm/linkage.h                |    2 +-
 arch/hexagon/include/asm/mem-layout.h             |    2 +-
 arch/hexagon/include/asm/mmu.h                    |    2 +-
 arch/hexagon/include/asm/mmu_context.h            |    2 +-
 arch/hexagon/include/asm/module.h                 |    2 +-
 arch/hexagon/include/asm/page.h                   |    2 +-
 arch/hexagon/include/asm/perf_event.h             |    2 +-
 arch/hexagon/include/asm/pgalloc.h                |    2 +-
 arch/hexagon/include/asm/pgtable.h                |    2 +-
 arch/hexagon/include/asm/processor.h              |    2 +-
 arch/hexagon/include/asm/smp.h                    |    2 +-
 arch/hexagon/include/asm/spinlock.h               |    2 +-
 arch/hexagon/include/asm/spinlock_types.h         |    2 +-
 arch/hexagon/include/asm/string.h                 |    2 +-
 arch/hexagon/include/asm/suspend.h                |    2 +-
 arch/hexagon/include/asm/switch_to.h              |    2 +-
 arch/hexagon/include/asm/syscall.h                |    2 +-
 arch/hexagon/include/asm/thread_info.h            |    2 +-
 arch/hexagon/include/asm/time.h                   |    2 +-
 arch/hexagon/include/asm/timer-regs.h             |    2 +-
 arch/hexagon/include/asm/timex.h                  |    2 +-
 arch/hexagon/include/asm/tlb.h                    |    2 +-
 arch/hexagon/include/asm/tlbflush.h               |    2 +-
 arch/hexagon/include/asm/traps.h                  |    2 +-
 arch/hexagon/include/asm/uaccess.h                |    2 +-
 arch/hexagon/include/asm/user.h                   |   81 ---------------------
 arch/hexagon/include/asm/vdso.h                   |    2 +-
 arch/hexagon/include/asm/vm_fault.h               |    2 +-
 arch/hexagon/include/asm/vm_mmu.h                 |    2 +-
 arch/hexagon/include/uapi/asm/Kbuild              |   12 +++
 arch/hexagon/include/{ => uapi}/asm/bitsperlong.h |    2 +-
 arch/hexagon/include/{ => uapi}/asm/byteorder.h   |    2 +-
 arch/hexagon/include/{ => uapi}/asm/kvm_para.h    |    0
 arch/hexagon/include/{ => uapi}/asm/param.h       |    2 +-
 arch/hexagon/include/{ => uapi}/asm/ptrace.h      |    2 +-
 arch/hexagon/include/{ => uapi}/asm/registers.h   |   17 +----
 arch/hexagon/include/{ => uapi}/asm/setup.h       |    2 +-
 arch/hexagon/include/{ => uapi}/asm/sigcontext.h  |    2 +-
 arch/hexagon/include/{ => uapi}/asm/signal.h      |    2 +-
 arch/hexagon/include/{ => uapi}/asm/swab.h        |    2 +-
 arch/hexagon/include/{ => uapi}/asm/unistd.h      |    2 +-
 arch/hexagon/include/uapi/asm/user.h              |   63 ++++++++++++++++
 arch/hexagon/kernel/asm-offsets.c                 |    2 +-
 arch/hexagon/kernel/dma.c                         |    2 +-
 arch/hexagon/kernel/head.S                        |    2 +-
 arch/hexagon/kernel/hexagon_ksyms.c               |    2 +-
 arch/hexagon/kernel/irq_cpu.c                     |    2 +-
 arch/hexagon/kernel/kgdb.c                        |    2 +-
 arch/hexagon/kernel/module.c                      |    2 +-
 arch/hexagon/kernel/process.c                     |    2 +-
 arch/hexagon/kernel/ptrace.c                      |    2 +-
 arch/hexagon/kernel/reset.c                       |    2 +-
 arch/hexagon/kernel/setup.c                       |    2 +-
 arch/hexagon/kernel/signal.c                      |    2 +-
 arch/hexagon/kernel/smp.c                         |    2 +-
 arch/hexagon/kernel/stacktrace.c                  |    2 +-
 arch/hexagon/kernel/syscall.c                     |    2 +-
 arch/hexagon/kernel/syscalltab.c                  |    2 +-
 arch/hexagon/kernel/time.c                        |    2 +-
 arch/hexagon/kernel/topology.c                    |    2 +-
 arch/hexagon/kernel/trampoline.S                  |    2 +-
 arch/hexagon/kernel/traps.c                       |    2 +-
 arch/hexagon/kernel/vdso.c                        |    2 +-
 arch/hexagon/kernel/vm_entry.S                    |    2 +-
 arch/hexagon/kernel/vm_events.c                   |    2 +-
 arch/hexagon/kernel/vm_init_segtable.S            |    2 +-
 arch/hexagon/kernel/vm_ops.S                      |    2 +-
 arch/hexagon/kernel/vm_switch.S                   |    2 +-
 arch/hexagon/kernel/vm_vectors.S                  |    2 +-
 arch/hexagon/kernel/vmlinux.lds.S                 |    2 +-
 arch/hexagon/lib/checksum.c                       |    2 +-
 arch/hexagon/lib/io.c                             |    2 +-
 arch/hexagon/lib/memcpy.S                         |    2 +-
 arch/hexagon/lib/memset.S                         |    2 +-
 arch/hexagon/mm/cache.c                           |    2 +-
 arch/hexagon/mm/copy_from_user.S                  |    2 +-
 arch/hexagon/mm/copy_to_user.S                    |    2 +-
 arch/hexagon/mm/copy_user_template.S              |    2 +-
 arch/hexagon/mm/init.c                            |    2 +-
 arch/hexagon/mm/ioremap.c                         |    2 +-
 arch/hexagon/mm/pgalloc.c                         |    2 +-
 arch/hexagon/mm/strnlen_user.S                    |    2 +-
 arch/hexagon/mm/uaccess.c                         |    2 +-
 arch/hexagon/mm/vm_fault.c                        |    2 +-
 arch/hexagon/mm/vm_tlb.c                          |    2 +-
 105 files changed, 175 insertions(+), 199 deletions(-)
 delete mode 100644 arch/hexagon/include/asm/user.h
 rename arch/hexagon/include/{ => uapi}/asm/bitsperlong.h (92%)
 rename arch/hexagon/include/{ => uapi}/asm/byteorder.h (92%)
 rename arch/hexagon/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/param.h (91%)
 rename arch/hexagon/include/{ => uapi}/asm/ptrace.h (94%)
 rename arch/hexagon/include/{ => uapi}/asm/registers.h (85%)
 rename arch/hexagon/include/{ => uapi}/asm/setup.h (92%)
 rename arch/hexagon/include/{ => uapi}/asm/sigcontext.h (93%)
 rename arch/hexagon/include/{ => uapi}/asm/signal.h (92%)
 rename arch/hexagon/include/{ => uapi}/asm/swab.h (91%)
 rename arch/hexagon/include/{ => uapi}/asm/unistd.h (93%)
 create mode 100644 arch/hexagon/include/uapi/asm/user.h

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
