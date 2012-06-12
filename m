Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab2FLEbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 00:31:45 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:16480 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2FLEbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 00:31:43 -0400
Date: Tue, 12 Jun 2012 14:10:13 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201206120410.q5C4ADGw020486@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch fixes for 3.5
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you plase pull the m68knommu git tree, for-linux branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

It contains five fixes. Four fix build problems introduced by recent clean
up and merging of the m68k timer and ptrace code. The other fixes the 528x
ColdFire CPU QSPI base address definition, missed in the ColdFire QSPI
cleanup.

Thanks
Greg



The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:
  Linus Torvalds (1):
        Linux 3.5-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (4):
      m68k: fix inclusion of arch_gettimeoffset for non-MMU 68k classic CPU types
      m68knommu: fix 68328 local setting of timer interrupt handler
      m68knommu: fix 68360 local setting of timer interrupt handler
      m68k: make syscall_trace_enter/leave exist for non-MMU classic m68k types

Steven King (1):
      m68knommu: m528x qspi definition fix

 arch/m68k/include/asm/m528xsim.h  |    2 +-
 arch/m68k/kernel/ptrace.c         |    2 +-
 arch/m68k/kernel/time.c           |    4 ++--
 arch/m68k/platform/68328/timers.c |    6 ++++--
 arch/m68k/platform/68360/config.c |    7 +++++--
 5 files changed, 13 insertions(+), 8 deletions(-)
