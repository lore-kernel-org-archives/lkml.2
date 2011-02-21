Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab1BUBTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 20:19:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55719 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab1BUBTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 20:19:48 -0500
Date: Mon, 21 Feb 2011 12:19:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: linux-next: manual merge of the hwmon-staging tree with the
 jdelvare-hwmon tree
Message-Id: <20110221121944.57f2ecfb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Today's linux-next merge of the hwmon-staging tree got a conflict in
drivers/hwmon/Makefile between commits
bb6cd76e2364b13de54314aeadd9f61b75335caa ("Let Kconfig handle lis3lv02d
dependencies") and d8f00f1b531b25ac96a39385617ff1718bc8474b ("Move
lis3lv02d drivers to drivers/misc") from the jdelvare-hwmon tree and
commit 2c37a4a61ef4efaa7a802e0757d783d9b54ad064 ("hwmon: Add support for
Lineage Compact Power Line PEM devices") from the hwmon-staging tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hwmon/Makefile
index 753117c,4681981..0000000
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@@ -62,6 -62,10 +62,7 @@@ obj-$(CONFIG_SENSORS_JC42)	+= jc42.
  obj-$(CONFIG_SENSORS_JZ4740)	+= jz4740-hwmon.o
  obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
  obj-$(CONFIG_SENSORS_K10TEMP)	+= k10temp.o
+ obj-$(CONFIG_SENSORS_LINEAGE)	+= lineage-pem.o
 -obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
 -obj-$(CONFIG_SENSORS_LIS3_SPI)	+= lis3lv02d.o lis3lv02d_spi.o
 -obj-$(CONFIG_SENSORS_LIS3_I2C)	+= lis3lv02d.o lis3lv02d_i2c.o
  obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
  obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
  obj-$(CONFIG_SENSORS_LM73)	+= lm73.o
