Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1BWFqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:46:04 -0500
Received: from mail.perches.com ([173.55.12.10]:3852 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab1BWFma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:30 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] MAINTAINERS: Change web links from wiki-analog to wiki.analog
Date: Tue, 22 Feb 2011 21:41:55 -0800
Message-Id: <266c414d5dde68db0fe1cd7ce898f80c69e18e1e.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wiki-analog doesn't seem to work, but wiki.analog does.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 74128bb..3c22026 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -288,35 +288,35 @@ F:	sound/pci/ad1889.*
 AD525X ANALOG DEVICES DIGITAL POTENTIOMETERS DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD5254
+W:	http://wiki.analog.com/AD5254
 S:	Supported
 F:	drivers/misc/ad525x_dpot.c
 
 AD5398 CURRENT REGULATOR DRIVER (AD5398/AD5821)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD5398
+W:	http://wiki.analog.com/AD5398
 S:	Supported
 F:	drivers/regulator/ad5398.c
 
 AD714X CAPACITANCE TOUCH SENSOR DRIVER (AD7142/3/7/8/7A)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD7142
+W:	http://wiki.analog.com/AD7142
 S:	Supported
 F:	drivers/input/misc/ad714x.c
 
 AD7877 TOUCHSCREEN DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD7877
+W:	http://wiki.analog.com/AD7877
 S:	Supported
 F:	drivers/input/touchscreen/ad7877.c
 
 AD7879 TOUCHSCREEN DRIVER (AD7879/AD7889)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/AD7879
+W:	http://wiki.analog.com/AD7879
 S:	Supported
 F:	drivers/input/touchscreen/ad7879.c
 
@@ -342,7 +342,7 @@ F:	drivers/net/wireless/adm8211.*
 ADP5520 BACKLIGHT DRIVER WITH IO EXPANDER (ADP5520/ADP5501)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/ADP5520
+W:	http://wiki.analog.com/ADP5520
 S:	Supported
 F:	drivers/mfd/adp5520.c
 F:	drivers/video/backlight/adp5520_bl.c
@@ -353,7 +353,7 @@ F:	drivers/input/keyboard/adp5520-keys.c
 ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/ADP5588
+W:	http://wiki.analog.com/ADP5588
 S:	Supported
 F:	drivers/input/keyboard/adp5588-keys.c
 F:	drivers/gpio/adp5588-gpio.c
@@ -361,7 +361,7 @@ F:	drivers/gpio/adp5588-gpio.c
 ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/ADP8860
+W:	http://wiki.analog.com/ADP8860
 S:	Supported
 F:	drivers/video/backlight/adp8860_bl.c
 
@@ -380,7 +380,7 @@ F:	drivers/hwmon/adt7475.c
 ADXL34X THREE-AXIS DIGITAL ACCELEROMETER DRIVER (ADXL345/ADXL346)
 M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	device-driver-devel@blackfin.uclinux.org
-W:	http://wiki-analog.com/ADXL345
+W:	http://wiki.analog.com/ADXL345
 S:	Supported
 F:	drivers/input/misc/adxl34x.c
 
@@ -520,7 +520,7 @@ F:	drivers/infiniband/hw/amso1100/
 ANALOG DEVICES INC ASOC CODEC DRIVERS
 L:	device-driver-devel@blackfin.uclinux.org
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-W:	http://wiki-analog.com/
+W:	http://wiki.analog.com/
 S:	Supported
 F:	sound/soc/codecs/ad1*
 F:	sound/soc/codecs/adau*
-- 
1.7.4.rc3

