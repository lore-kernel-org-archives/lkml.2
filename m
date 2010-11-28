Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0K1Sbw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 13:31:52 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48061 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab0K1Sbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 13:31:51 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] MAINTAINERS: update Analog Devices support info
Date: Sun, 28 Nov 2010 13:36:41 -0500
Message-Id: <1290969401-29014-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Add more Analog Devices driver entries and refine the differences between
Blackfin-specific code and processor independent drivers.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 MAINTAINERS |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3be8b3..5e7aecf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -286,6 +286,41 @@ L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/pci/ad1889.*
 
+AD525X ANALOG DEVICES DIGITAL POTENTIOMETERS DRIVER
+M:	Michael Hennerich <michael.hennerich@analog.com>
+L:	device-driver-devel@blackfin.uclinux.org
+W:	http://wiki-analog.com/AD5254
+S:	Supported
+F:	drivers/misc/ad525x_dpot.c
+
+AD5398 CURRENT REGULATOR DRIVER (AD5398/AD5821)
+M:	Michael Hennerich <michael.hennerich@analog.com>
+L:	device-driver-devel@blackfin.uclinux.org
+W:	http://wiki-analog.com/AD5398
+S:	Supported
+F:	drivers/regulator/ad5398.c
+
+AD714X CAPACITANCE TOUCH SENSOR DRIVER (AD7142/3/7/8/7A)
+M:	Michael Hennerich <michael.hennerich@analog.com>
+L:	device-driver-devel@blackfin.uclinux.org
+W:	http://wiki-analog.com/AD7142
+S:	Supported
+F:	drivers/input/misc/ad714x.c
+
+AD7877 TOUCHSCREEN DRIVER
+M:	Michael Hennerich <michael.hennerich@analog.com>
+L:	device-driver-devel@blackfin.uclinux.org
+W:	http://wiki-analog.com/AD7877
+S:	Supported
+F:	drivers/input/touchscreen/ad7877.c
+
+AD7879 TOUCHSCREEN DRIVER (AD7879/AD7889)
+M:	Michael Hennerich <michael.hennerich@analog.com>
+L:	device-driver-devel@blackfin.uclinux.org
+W:	http://wiki-analog.com/AD7879
+S:	Supported
+F:	drivers/input/touchscreen/ad7879.c
+
 ADM1025 HARDWARE MONITOR DRIVER
 M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
@@ -305,6 +340,32 @@ W:	http://linuxwireless.org/
 S:	Orphan
 F:	drivers/net/wireless/adm8211.*
 
+ADP5520 BACKLIGHT DRIVER WITH IO EXPANDER (ADP5520/ADP5501)
+M:	Michael Hennerich <michael.hennerich@analog.com>
+L:	device-driver-devel@blackfin.uclinux.org
+W:	http://wiki-analog.com/ADP5520
+S:	Supported
+F:	drivers/mfd/adp5520.c
+F:	drivers/video/backlight/adp5520_bl.c
+F:	drivers/led/leds-adp5520.c
+F:	drivers/gpio/adp5520-gpio.c
+F:	drivers/input/keyboard/adp5520-keys.c
+
+ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
+M:	Michael Hennerich <michael.hennerich@analog.com>
+L:	device-driver-devel@blackfin.uclinux.org
+W:	http://wiki-analog.com/ADP5588
+S:	Supported
+F:	drivers/input/keyboard/adp5588-keys.c
+F:	drivers/gpio/adp5588-gpio.c
+
+ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
+M:	Michael Hennerich <michael.hennerich@analog.com>
+L:	device-driver-devel@blackfin.uclinux.org
+W:	http://wiki-analog.com/ADP8860
+S:	Supported
+F:	drivers/video/backlight/adp8860_bl.c
+
 ADT746X FAN DRIVER
 M:	Colin Leroy <colin@colino.net>
 S:	Maintained
@@ -317,6 +378,13 @@ S:	Maintained
 F:	Documentation/hwmon/adt7475
 F:	drivers/hwmon/adt7475.c
 
+ADXL34X THREE-AXIS DIGITAL ACCELEROMETER DRIVER (ADXL345/ADXL346)
+M:	Michael Hennerich <michael.hennerich@analog.com>
+L:	device-driver-devel@blackfin.uclinux.org
+W:	http://wiki-analog.com/ADXL345
+S:	Supported
+F:	drivers/input/misc/adxl34x.c
+
 ADVANSYS SCSI DRIVER
 M:	Matthew Wilcox <matthew@wil.cx>
 L:	linux-scsi@vger.kernel.org
@@ -441,17 +509,23 @@ L:	linux-rdma@vger.kernel.org
 S:	Maintained
 F:	drivers/infiniband/hw/amso1100/
 
-ANALOG DEVICES INC ASOC DRIVERS
-L:	uclinux-dist-devel@blackfin.uclinux.org
+ANALOG DEVICES INC ASOC CODEC DRIVERS
+L:	device-driver-devel@blackfin.uclinux.org
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-W:	http://blackfin.uclinux.org/
+W:	http://wiki-analog.com/
 S:	Supported
-F:	sound/soc/blackfin/*
 F:	sound/soc/codecs/ad1*
 F:	sound/soc/codecs/adau*
 F:	sound/soc/codecs/adav*
 F:	sound/soc/codecs/ssm*
 
+ANALOG DEVICES INC ASOC DRIVERS
+L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
+W:	http://blackfin.uclinux.org/
+S:	Supported
+F:	sound/soc/blackfin/*
+
 AOA (Apple Onboard Audio) ALSA DRIVER
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linuxppc-dev@lists.ozlabs.org
-- 
1.7.3.2

