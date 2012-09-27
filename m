Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2I0SfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:35:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2I0SfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:35:05 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Sep 2012 22:49:11 +0200
From: Richard Weinberger <richard@nod.at>
To: <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,
        <user-mode-linux-devel@lists.sourceforge.net>
Subject: [GIT PULL] UML fixes for 3.6-final
Message-ID: <a6566f1b02f315ebb5669a59b1acce21@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 
5e19997a742c7c8203be628a7a69babc3bcf01a4:

  Merge tag 'for-linus' of 
git://linux-c6x.org/git/projects/linux-c6x-upstreaming (2012-09-26 
14:28:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git 
for-linus-3.6-rc-final

Al Viro (4):
      um: take cleaning singlestep to start_thread()
      um: don't leak floating point state and segment registers on 
execve()
      um: let signal_delivered() do SIGTRAP on singlestepping into 
handler
      um: kill thread->forking

Geert Uytterhoeven (1):
      um: Preinclude include/linux/kern_levels.h

Richard Weinberger (1):
      um: Fix IPC on um

 arch/um/include/asm/processor-generic.h    |    9 ---------
 arch/um/include/shared/common-offsets.h    |   10 ----------
 arch/um/include/shared/user.h              |   11 +++++++++++
 arch/um/kernel/exec.c                      |   25 
++++++-------------------
 arch/um/kernel/process.c                   |    8 ++++----
 arch/um/kernel/signal.c                    |    6 +++++-
 arch/um/kernel/syscall.c                   |   24 
++++++++++++------------
 arch/um/scripts/Makefile.rules             |    2 +-
 arch/x86/um/Kconfig                        |    1 +
 arch/x86/um/shared/sysdep/kernel-offsets.h |    3 ---
 arch/x86/um/shared/sysdep/syscalls.h       |    2 ++
 arch/x86/um/signal.c                       |    6 ------
 arch/x86/um/sys_call_table_32.c            |    2 +-
 arch/x86/um/syscalls_32.c                  |   27 
+++++++--------------------
 arch/x86/um/syscalls_64.c                  |   23 
+++--------------------
 15 files changed, 53 insertions(+), 106 deletions(-)

