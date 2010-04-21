Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0DUFQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:16:57 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:50355 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983Ab0DUFQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:16:54 -0400
Date: Wed, 21 Apr 2010 15:22:17 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <201004210522.o3L5MHnC027492@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
       <linux-m68k@vger.kernel.org>
Subject: [git pull] m68knommu arch bug fixes
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

to get a small collection of m68knommu arch bug fixes and one uclinux
flat file error message improvement.

Thanks
Greg



The following changes since commit 05ce7bfe547c9fa967d9cab6c37867a9cb6fb3fa:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../jack/linux-fs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (1):
      m68knommu: remove a duplicate vector setting line for 68360

Jun Sun (1):
      uclinux: error message when FLAT reloc symbol is invalid, v2

Maxim Kuvyrkov (1):
      Fix m68k-uclinux's rt_sigreturn trampoline

Philip Nye (1):
      m68knommu: correct the CC flags for Coldfire M5272 targets

Philippe De Muyter (2):
      m68knommu: fix coldfire tcdrain
      m68knommu: allow 4 coldfire serial ports

 arch/m68k/include/asm/mcfuart.h      |    5 +++++
 arch/m68knommu/Makefile              |    2 +-
 arch/m68knommu/kernel/entry.S        |    2 +-
 arch/m68knommu/platform/68360/ints.c |    1 -
 drivers/serial/mcf.c                 |    6 ++++--
 fs/binfmt_flat.c                     |    2 +-
 6 files changed, 12 insertions(+), 6 deletions(-)
