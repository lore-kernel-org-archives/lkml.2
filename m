Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1FWCQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:16:04 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50173 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab1FWCQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=D3yZq0LkUeagkVHhJ/IeNWKtoCu7c0ZJpfscq62CX4dLVIOe6uHjKfVT9ylqjtW8OG
         KSwyuUWqEhhFMvOJ/JyeUl3GdUBJkQOaNeh4mIi13Skhm/i7dqSdi3iNGxwZ6i0sSM5A
         tF51kj0G226YIWlveBCW6YmffZrAXwT/wIPsw=
Subject: [PATCH 1/3] mfd: Add Makefile and Kconfig Entries for tps65911
 comparator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 10:15:51 +0800
Message-ID: <1308795351.15248.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Base on Mark's comment [1], I make the Kconfig entry invisible to users.
[1] https://lkml.org/lkml/2011/5/14/136

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Jorge,
I don't have this device handy, can you help to test this serial of patches?
Thanks,
Axel

 drivers/mfd/Kconfig  |    3 +++
 drivers/mfd/Makefile |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 519ebab..76a7223 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -751,6 +751,9 @@ config MFD_TPS65910
 	  if you say yes here you get support for the TPS65910 series of
 	  Power Management chips.
 
+config TPS65911_COMPARATOR
+	tristate
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5309ec3..35c5476 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -99,3 +99,4 @@ obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
 obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-irq.o
+obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
-- 
1.7.4.1



