Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab0HNPg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 11:36:29 -0400
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:51170 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751274Ab0HNPg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 11:36:28 -0400
X-Greylist: delayed 1626 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Aug 2010 11:36:28 EDT
Date: Sat, 14 Aug 2010 16:36:25 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com
Subject: [PULL] Please pull bjdooks' for-linus/samsung-2636
Message-ID: <20100814153625.GA31271@ben-laptop.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, please pull

The following changes since commit 45d7f32c7a43cbb9592886d38190e379e2eb2226:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../cmetcalf/linux-tile

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-linus/samsung-2635

Ben Dooks (3):
      ARM: S3C64XX: Update consistent DMA size to 8MiB
      ARM: SMDK6410: Make virtual screen twice depth of real
      Merge branch 'for-2636/s3c64xx' into for-linus/samsung-2635

Darius Augulis (3):
      ARM: S3C64XX: Support for Real6410
      ARM: mach-real6410: add dm9000 ethernet support for mach-real6410
      ARM: mach-real6410: add sdhc device support

Kukjin Kim (1):
      ARM: SAMSUNG: Fix on build warning about dependency in Kconfig

Linus Walleij (1):
      DMAENGINE: correct PL080 register header file

Maurus Cuelenaere (3):
      ARM: S3C64XX: Move SmartQ LCD control platform definition to shared file
      ARM: S3C64XX: Set wifi and iNAND as permanently connected SD devices on SmartQ boards
      ARM: S3C64XX: Add audio support to SmartQ

Patrick Georgi (1):
      ARM: S3C64XX: Framebuffer fix for SmartQ5

 arch/arm/include/asm/hardware/pl080.h       |    4 +-
 arch/arm/mach-s3c64xx/Kconfig               |    9 ++
 arch/arm/mach-s3c64xx/Makefile              |    1 +
 arch/arm/mach-s3c64xx/dma.c                 |    2 +-
 arch/arm/mach-s3c64xx/include/mach/memory.h |    2 +
 arch/arm/mach-s3c64xx/mach-real6410.c       |  152 +++++++++++++++++++++++++++
 arch/arm/mach-s3c64xx/mach-smartq.c         |   40 +++++++-
 arch/arm/mach-s3c64xx/mach-smartq5.c        |   36 +------
 arch/arm/mach-s3c64xx/mach-smartq7.c        |   28 -----
 arch/arm/mach-s3c64xx/mach-smdk6410.c       |    2 +
 arch/arm/plat-samsung/Kconfig               |    2 +-
 11 files changed, 213 insertions(+), 65 deletions(-)
 create mode 100644 arch/arm/mach-s3c64xx/mach-real6410.c

