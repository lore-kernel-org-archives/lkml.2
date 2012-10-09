Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2JIUPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:15:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab2JIUPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:15:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jochen Friedrich <jochen@scram.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, Pavel Machek <pavel@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Wan ZongShun <mcuos.com@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-pcmcia@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, stable@vger.kernel.org
Subject: [PATCH v2 0/8]  ARM: mostly harmless gcc warnings
Date: Tue,  9 Oct 2012 22:13:50 +0200
Message-Id: <1349813638-4617-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
X-Provags-ID: V02:K0:P63FroCm+H9NjkTUQbw4xYjrh91GWYwhZ1NFjG0tLd5
 zbpCGDeMyrUqMz3OdB0O1HII8YeToWYPjZhYstwjXKMxtu1ZnV
 ZocTLJarNvcUQd6qBvr8Fu4C5XleiHMa3laCnME7oVS86FhqKs
 lLiKPlrNouI9kFrKMmgBFiHfv5f23rtRvis8cE5keYBJJZDak8
 TJokOjAXk1yS8i3AK+mufXGEAgVstMNbtkeOU0vXZOCQMoGo7D
 vfhtCpLU5PEKIIWKU/2Y4kwAWAQpZKU17uZGDD/9L2tkixbkuw
 g85VJ2OrvBCoTWkIWqjds93MEJrTiaf7+dQx/UWGrX67avaR4r
 tnTLNfT2mEHXxz/hrtOYSW8dmq9kLt4LpQs6ZxhRg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most patches from the first time this was posted have been
adopted by a subsystem maintainer or were show to be obsolete.
Here are the remaining ones again.

I'm planning to submit those patches that are still necessary
by the time we have an -rc1 through the arm-soc tree, but
my preference is still to have them go through the subsystem
maintainers.

Olof: should we add it to for-next?

	Arnd

Arnd Bergmann (8):
  SCSI: ARM: ncr5380/oak uses no interrupts
  SCSI: ARM: make fas216_dumpinfo function conditional
  mm/slob: use min_t() to compare ARCH_SLAB_MINALIGN
  USB: EHCI: mark ehci_orion_conf_mbus_windows __devinit
  clk: don't mark clkdev_add_table as init
  pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops
  video: mark nuc900fb_map_video_memory as __devinit
  spi/s3c64xx: use correct dma_transfer_direction type

 drivers/clk/clkdev.c            |    2 +-
 drivers/pcmcia/pxa2xx_sharpsl.c |    2 +-
 drivers/scsi/arm/fas216.c       |    2 +-
 drivers/scsi/arm/oak.c          |    1 +
 drivers/spi/spi-s3c64xx.c       |    2 +-
 drivers/usb/host/ehci-orion.c   |    2 +-
 drivers/video/nuc900fb.c        |    2 +-
 mm/slob.c                       |    6 +++---
 8 files changed, 10 insertions(+), 9 deletions(-)

-- 
1.7.10

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jochen Friedrich <jochen@scram.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-pcmcia@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: spi-devel-general@lists.sourceforge.net
Cc: stable@vger.kernel.org
