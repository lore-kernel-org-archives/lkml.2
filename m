Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2JMVWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 17:22:16 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:53359 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab2JMVWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 17:22:15 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQ] IXP4xx changes for Linux 3.7
Date: Sat, 13 Oct 2012 23:22:12 +0200
Message-ID: <m3bog6m5iz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull my ARM IXP4xx changes for 3.7:

The following changes since commit 4d7127dace8cf4b05eb7c8c8531fc204fbb195f4:

"Merge branch 'for-linus' of git://git.kernel.org/.../jmorris/linux-security"
(2012-10-13 11:29:00 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux.git next

for you to fetch changes up to b94740b3b38fd8e37fcd3bb06a18ec2796061c7d:
  IXP4xx: use __iomem for MMIO (2012-10-13 20:37:30 +0200)

Build-tested for now. This is based on your current tree tip because it
depends on commits following 3.6 release.

Thanks.

----------------------------------------------------------------
Arnd Bergmann (1):
      IXP4xx: use __iomem for MMIO

Krzysztof Hałasa (9):
      IXP4xx: Fix Goramo MultiLink platform compilation.
      IXP4xx: Fix off-by-one bug in Goramo MultiLink platform.
      IXP4xx: HW pseudo-random generator is available on IXP45x/46x only.
      IXP4xx: ixp4xx_crypto driver requires Queue Manager and NPE drivers.
      IXP4xx: Remove time limit for PCI TRDY to enable use of slow devices.
      WAN: Remove redundant HDLC info printed by IXP4xx HSS driver.
      IXP4xx crypto: MOD_AES{128,192,256} already include key size.
      IXP4xx: Always ioremap() Queue Manager MMIO region at boot.
      IXP4xx: map CPU config registers within VMALLOC region.

Tim Gardner (1):
      ixp4xx: Declare MODULE_FIRMWARE usage

 arch/arm/mach-ixp4xx/common-pci.c               |  1 +
 arch/arm/mach-ixp4xx/common.c                   | 13 +++++--------
 arch/arm/mach-ixp4xx/goramo_mlr.c               |  3 ++-
 arch/arm/mach-ixp4xx/include/mach/debug-macro.S |  4 ++--
 arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h | 46 +++++++++++++++++++--------------------------
 arch/arm/mach-ixp4xx/include/mach/qmgr.h        | 12 ++++++------
 arch/arm/mach-ixp4xx/ixp4xx_npe.c               |  9 ++++++++-
 arch/arm/mach-ixp4xx/ixp4xx_qmgr.c              | 12 +-----------
 drivers/char/hw_random/Kconfig                  |  6 +++---
 drivers/char/hw_random/ixp4xx-rng.c             |  5 ++++-
 drivers/crypto/Kconfig                          |  2 +-
 drivers/crypto/ixp4xx_crypto.c                  | 12 ++++++------
 drivers/net/wan/ixp4xx_hss.c                    |  2 +-
 13 files changed, 59 insertions(+), 68 deletions(-)

-- 
Krzysztof Halasa
