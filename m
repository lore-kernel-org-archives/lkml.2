Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1EXHRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:17:23 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:24017 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1EXHRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:17:19 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "Frysinger, Michael" <Michael.Frysinger@analog.com>
Date: Tue, 24 May 2011 08:17:11 +0100
Subject: FW: [PATCH] MAINTAINERS: Fix Analog Devices mailinglist address
Thread-Topic: [PATCH] MAINTAINERS: Fix Analog Devices mailinglist address
Thread-Index: AcwLPBJ839WXOjlLQwK9e1A3G4r9XgOpeyqg
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713AAF293A45@LIMKCMBX1.ad.analog.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

There is a small typo in the Analog Devices driver mailinglist address.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>

---
 MAINTAINERS |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9f926c0..97b6584 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -287,35 +287,35 @@ F:        sound/pci/ad1889.*

 AD525X ANALOG DEVICES DIGITAL POTENTIOMETERS DRIVER
 M:     Michael Hennerich <michael.hennerich@analog.com>
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 W:     http://wiki.analog.com/AD5254
 S:     Supported
 F:     drivers/misc/ad525x_dpot.c

 AD5398 CURRENT REGULATOR DRIVER (AD5398/AD5821)
 M:     Michael Hennerich <michael.hennerich@analog.com>
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 W:     http://wiki.analog.com/AD5398
 S:     Supported
 F:     drivers/regulator/ad5398.c

 AD714X CAPACITANCE TOUCH SENSOR DRIVER (AD7142/3/7/8/7A)
 M:     Michael Hennerich <michael.hennerich@analog.com>
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 W:     http://wiki.analog.com/AD7142
 S:     Supported
 F:     drivers/input/misc/ad714x.c

 AD7877 TOUCHSCREEN DRIVER
 M:     Michael Hennerich <michael.hennerich@analog.com>
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 W:     http://wiki.analog.com/AD7877
 S:     Supported
 F:     drivers/input/touchscreen/ad7877.c

 AD7879 TOUCHSCREEN DRIVER (AD7879/AD7889)
 M:     Michael Hennerich <michael.hennerich@analog.com>
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 W:     http://wiki.analog.com/AD7879
 S:     Supported
 F:     drivers/input/touchscreen/ad7879.c
@@ -341,7 +341,7 @@ F:  drivers/net/wireless/adm8211.*

 ADP5520 BACKLIGHT DRIVER WITH IO EXPANDER (ADP5520/ADP5501)
 M:     Michael Hennerich <michael.hennerich@analog.com>
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 W:     http://wiki.analog.com/ADP5520
 S:     Supported
 F:     drivers/mfd/adp5520.c
@@ -352,7 +352,7 @@ F:  drivers/input/keyboard/adp5520-keys.c

 ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
 M:     Michael Hennerich <michael.hennerich@analog.com>
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 W:     http://wiki.analog.com/ADP5588
 S:     Supported
 F:     drivers/input/keyboard/adp5588-keys.c
@@ -360,7 +360,7 @@ F:  drivers/gpio/adp5588-gpio.c

 ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
 M:     Michael Hennerich <michael.hennerich@analog.com>
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 W:     http://wiki.analog.com/ADP8860
 S:     Supported
 F:     drivers/video/backlight/adp8860_bl.c
@@ -387,7 +387,7 @@ F:  drivers/hwmon/adt7475.c

 ADXL34X THREE-AXIS DIGITAL ACCELEROMETER DRIVER (ADXL345/ADXL346)
 M:     Michael Hennerich <michael.hennerich@analog.com>
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 W:     http://wiki.analog.com/ADXL345
 S:     Supported
 F:     drivers/input/misc/adxl34x.c
@@ -526,7 +526,7 @@ S:  Maintained
 F:     drivers/infiniband/hw/amso1100/

 ANALOG DEVICES INC ASOC CODEC DRIVERS
-L:     device-driver-devel@blackfin.uclinux.org
+L:     device-drivers-devel@blackfin.uclinux.org
 L:     alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:     http://wiki.analog.com/
 S:     Supported
--
1.7.2.5



