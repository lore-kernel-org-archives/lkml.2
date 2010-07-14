Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab0GNHXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 03:23:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:57812 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab0GNHW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 03:22:58 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 17:22:43 +1000
Message-ID: <1279092163.28659.464.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some late fixed for some freescale embedded platforms
for 2.6.35. A bit late but since it only touch their platform
code I don't really have an objection.

Cheers,
Ben.

The following changes since commit 1c5474a65bf15a4cb162dfff86d6d0b5a08a740c:
  Linus Torvalds (1):
        Linux 2.6.35-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Vorontsov (3):
      powerpc/cpm: Reintroduce global spi_pram struct (fixes build issue)
      powerpc/cpm1: Fix build with various CONFIG_*_UCODE_PATCH combinations
      powerpc/cpm1: Mark micropatch code/data static and __init

Matthew McClintock (1):
      powerpc/fsl-booke: Fix address issue when using relocatable kernels

 arch/powerpc/include/asm/cpm.h                |   24 ++++++++++++++++++++
 arch/powerpc/include/asm/cpm1.h               |    3 +-
 arch/powerpc/kernel/fsl_booke_entry_mapping.S |    4 +--
 arch/powerpc/sysdev/micropatch.c              |   30 +++++++++++++++----------
 drivers/spi/spi_mpc8xxx.c                     |   22 ------------------
 5 files changed, 45 insertions(+), 38 deletions(-)


