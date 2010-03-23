Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab0CWEKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:10:03 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:52060 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719Ab0CWEKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:10:00 -0400
Date: Tue, 23 Mar 2010 14:14:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <201003230414.o2N4EdjP003316@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
       <linux-m68k@vger.kernel.org>
Subject: [git pull] m68knommu arch fixes
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull to get some m68knommu fixes. Nothing too major in here,
adding QSPI platform support and some minor fixes.

Thanks
Greg



The following changes since commit 6ebdc661b608671e9ca572af8bb42d58108cc008:
  Linus Torvalds (1):
        Merge branch 'next-devicetree' of git://git.secretlab.ca/git/linux-2.6

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

Steven King (1):
      m68knommu: Coldfire QSPI platform support

 arch/m68k/include/asm/m520xsim.h      |    1 +
 arch/m68k/include/asm/m523xsim.h      |    5 +
 arch/m68k/include/asm/m5249sim.h      |    2 +
 arch/m68k/include/asm/m527xsim.h      |    7 ++
 arch/m68k/include/asm/m528xsim.h      |   67 +------------
 arch/m68k/include/asm/m532xsim.h      |    1 +
 arch/m68k/include/asm/mcfqspi.h       |   64 ++++++++++++
 arch/m68knommu/Makefile               |    2 +-
 arch/m68knommu/kernel/entry.S         |    2 +-
 arch/m68knommu/platform/520x/config.c |  149 +++++++++++++++++++++++++++
 arch/m68knommu/platform/523x/config.c |  170 ++++++++++++++++++++++++++++++
 arch/m68knommu/platform/5249/config.c |  167 ++++++++++++++++++++++++++++++
 arch/m68knommu/platform/527x/config.c |  182 +++++++++++++++++++++++++++++++++
 arch/m68knommu/platform/528x/config.c |  137 +++++++++++++++++++++++++
 arch/m68knommu/platform/532x/config.c |  124 ++++++++++++++++++++++
 arch/m68knommu/platform/68360/ints.c  |    1 -
 fs/binfmt_flat.c                      |    2 +-
 17 files changed, 1013 insertions(+), 70 deletions(-)
 create mode 100644 arch/m68k/include/asm/mcfqspi.h
