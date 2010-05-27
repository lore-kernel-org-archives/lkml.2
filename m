Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0E0Mzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:55:32 -0400
Received: from khc.piap.pl ([195.187.100.11]:44956 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab0E0Mza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:55:30 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 08:55:30 EDT
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQ] IXP4xx (ARM): pull request
Date: Thu, 27 May 2010 14:49:08 +0200
Message-ID: <m37hmp33y3.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since Linus 2.6.34 are available in the git
repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git ixp4xx

Krzysztof Hałasa (5):
      IXP4xx: Prevent HSS transmitter lockup by disabling FRaMe signals.
      IXP4xx: Fix ixp4xx_crypto little-endian operation.
      IXP4xx: Make mdio_bus struct static in the Ethernet driver.
      IXP4xx: Fix sparse warnings in I/O primitives.
      IXP4xx: Fix LL debugging on little-endian CPU.

Marc Zyngier (2) (support for a new platform):
      ixp4xx: base support for Arcom Vulcan
      ixp4xx/vulcan: add PCI support

 arch/arm/mach-ixp4xx/Kconfig                    |    8 +
 arch/arm/mach-ixp4xx/Makefile                   |    2 +
 arch/arm/mach-ixp4xx/include/mach/debug-macro.S |    2 +
 arch/arm/mach-ixp4xx/include/mach/io.h          |    6 +-
 arch/arm/mach-ixp4xx/vulcan-pci.c               |   73 +++++++
 arch/arm/mach-ixp4xx/vulcan-setup.c             |  246 +++++++++++++++++++++++
 drivers/crypto/ixp4xx_crypto.c                  |   21 ++
 drivers/net/arm/ixp4xx_eth.c                    |    2 +-
 drivers/net/wan/ixp4xx_hss.c                    |    2 +-
 9 files changed, 357 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mach-ixp4xx/vulcan-pci.c
 create mode 100644 arch/arm/mach-ixp4xx/vulcan-setup.c

TIA.
-- 
Krzysztof Halasa
