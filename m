Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2K2OYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:24:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60611 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab2K2OYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:24:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] ARM: final SoC fixes for 3.7
Date: Thu, 29 Nov 2012 14:24:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "arm@kernel.org" <arm@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Kukjin Kim <kgene.kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211291424.25711.arnd@arndb.de>
X-Provags-ID: V02:K0:1sXhRYF/cxp9uKn4S2hAobYYQOAWVKhGjlw0+Bmeyff
 rUGX2GbZt7ye2kJ7M78IS4+RO8uujWig9ISGRxf/yUIEu5Pd9/
 E0KDYIYbK9q9dpjjmc15Pn9p7qf9Hoe6DBJbk9tZDeuqlCwjZ7
 AxOytP+kObiLdSDBtOEi4OLOtKTVqrgdD+GuuQaoyD/iTu3S3m
 vA6aL/JYFYMaVlQpZlXJ1cNyblZZ2yXv/J97pgvFf2S5V4FOAJ
 R1Bovp5AdaLPTOEqPPcUp8ocouvRWVM71YdZWl3Xv1xUmMSTJv
 GIgNVaKhbh5OdEFwrQtgxW1giXy2D6TMA18Lmap+06Bhqdi/xM
 xKqYESOCAKUVNUe94/DM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These should be the last bug fixes you get from Olof and me for 3.7.
This is based on the previous one you pulled and there is nothing
spectacular in here. I'll follow up with a second pull request
knowing that those are probably too late now, but I'd like to let
you know about the ones that didn't make it and give you the chance
to pull those anyway if you prefer.

	Arnd

  Merge branch 'v3.7-samsung-fixes-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2012-11-22 20:43:37 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

for you to fetch changes up to 9434d24b11ccceeb39522965593ef2ddc9eb4e7c:

  Merge branch 'v3.7-samsung-fixes-4' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2012-11-29 15:07:27 +0100)

----------------------------------------------------------------

ARM: SoC fixes for 3.7

These are three fixes for the Marvell EBU family and one for the Samsung
s3c platforms. All of them are obvious should still make it into 3.7.

----------------------------------------------------------------
Arnd Bergmann (1):
      Merge branch 'v3.7-samsung-fixes-4' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Jason Gunthorpe (1):
      ARM: Kirkwood: Update PCI-E fixup

Olof Johansson (1):
      Merge tag 'orion_fixes_for_3.7' of git://git.infradead.org/users/jcooper/linux into fixes

Russell King - ARM Linux (2):
      Dove: Attempt to fix PMU/RTC interrupts
      Dove: Fix irq_to_pmu()

Sachin Kamat (1):
      ARM: S3C24XX: Fix potential NULL pointer dereference error

 arch/arm/Kconfig                     |    1 +
 arch/arm/mach-dove/include/mach/pm.h |    2 +-
 arch/arm/mach-dove/irq.c             |   14 +++++++++++++-
 arch/arm/mach-kirkwood/pcie.c        |   11 ++++++++---
 arch/arm/plat-s3c24xx/dma.c          |    9 +++++----
 5 files changed, 28 insertions(+), 9 deletions(-)
