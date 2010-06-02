Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab0FBUZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:25:04 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:41911 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab0FBUZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:25:01 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Jun 2010 14:24:38 -0600
X-Google-Sender-Auth: 4ry82Xvm3amKfEGMO2bEGXVLYdc
Message-ID: <AANLkTimdqrggRbKC2dZRIuMFe4y_99Oy1TO0oThsWboU@mail.gmail.com>
Subject: [git pull] OF-related build breakage fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
       Michael Guntsche <mike@it-loops.com>,
       Anatolij Gustschin <agust@denx.de>,
       Alexandre Bounine <alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a set of build fixes related to the of_node and of_match_table
device changes.  All trivial fixes.

Thanks,
g.

The following changes since commit aef4b9aaae1decc775778903922bd0075cce7a88:
  Linus Torvalds (1):
        Merge branch 'next' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge

Alexandre Bounine (1):
      of/powerpc: fix 85xx RapidIO device node pointer

Anatolij Gustschin (3):
      of/spi: mpc512x_psc_spi.c: Fix build failures
      of/mtd/nand: mpc5121_nfc.c: Fix build failures
      of/dma: mpc512x_dma.c: Fix build failures

Grant Likely (3):
      of/usb: fix build error due to of_node pointer move
      of/spi: Fix build failure on spi_ppc4xx.c
      of/rtc: rtc-mpc5121.c: Fix build failures

Michael Guntsche (1):
      watchdog: Fix build failure with OF changes

 arch/powerpc/sysdev/fsl_rio.c     |    2 +-
 drivers/dma/mpc512x_dma.c         |   10 +++++-----
 drivers/mtd/nand/mpc5121_nfc.c    |    8 ++++----
 drivers/rtc/rtc-mpc5121.c         |   14 ++++++++------
 drivers/spi/mpc512x_psc_spi.c     |   12 ++++++------
 drivers/spi/spi_ppc4xx.c          |    2 +-
 drivers/usb/host/ehci-xilinx-of.c |    2 +-
 drivers/watchdog/mpc8xxx_wdt.c    |    2 +-
 8 files changed, 27 insertions(+), 25 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
