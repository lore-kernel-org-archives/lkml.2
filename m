Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1EEPs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:48:56 -0400
Received: from smtp-out-227.synserver.de ([212.40.185.227]:1055 "HELO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754427Ab1EEPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:48:54 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 31570
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] MAINTAINERS: Fix Analog Devices mailinglist address
Date: Thu,  5 May 2011 17:48:33 +0200
Message-Id: <1304610513-16008-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a small typo in the Analog Devices driver mailinglist address.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 MAINTAINERS |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9f926c0..97b6584 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -287,35 +287,35 @@ F:	sound/pci/ad1889.*
 
 AD525X ANALOG DEVICES DIGITAL POTENTIOMETERS DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD5254
 S:	Supported
 F:	drivers/misc/ad525x_dpot.c
 
 AD5398 CURRENT REGULATOR DRIVER (AD5398/AD5821)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD5398
 S:	Supported
 F:	drivers/regulator/ad5398.c
 
 AD714X CAPACITANCE TOUCH SENSOR DRIVER (AD7142/3/7/8/7A)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD7142
 S:	Supported
 F:	drivers/input/misc/ad714x.c
 
 AD7877 TOUCHSCREEN DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD7877
 S:	Supported
 F:	drivers/input/touchscreen/ad7877.c
 
 AD7879 TOUCHSCREEN DRIVER (AD7879/AD7889)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD7879
 S:	Supported
 F:	drivers/input/touchscreen/ad7879.c
@@ -341,7 +341,7 @@ F:	drivers/net/wireless/adm8211.*
 
 ADP5520 BACKLIGHT DRIVER WITH IO EXPANDER (ADP5520/ADP5501)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP5520
 S:	Supported
 F:	drivers/mfd/adp5520.c
@@ -352,7 +352,7 @@ F:	drivers/input/keyboard/adp5520-keys.c
 
 ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP5588
 S:	Supported
 F:	drivers/input/keyboard/adp5588-keys.c
@@ -360,7 +360,7 @@ F:	drivers/gpio/adp5588-gpio.c
 
 ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP8860
 S:	Supported
 F:	drivers/video/backlight/adp8860_bl.c
@@ -387,7 +387,7 @@ F:	drivers/hwmon/adt7475.c
 
 ADXL34X THREE-AXIS DIGITAL ACCELEROMETER DRIVER (ADXL345/ADXL346)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADXL345
 S:	Supported
 F:	drivers/input/misc/adxl34x.c
@@ -526,7 +526,7 @@ S:	Maintained
 F:	drivers/infiniband/hw/amso1100/
 
 ANALOG DEVICES INC ASOC CODEC DRIVERS
-L:	device-driver-devel@blackfin.uclinux.org
+L:	device-drivers-devel@blackfin.uclinux.org
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://wiki.analog.com/
 S:	Supported
-- 
1.7.2.5

