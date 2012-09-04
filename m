Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2IDHH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 03:07:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36853 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab2IDHHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 03:07:09 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 1/3] leds-lp5523: support new LP55231 device
Thread-Topic: [PATCH 1/3] leds-lp5523: support new LP55231 device
Thread-Index: Ac2Ka8KDhSwa2ub7QAavP9BfE1BabA==
Date: Tue, 4 Sep 2012 07:06:11 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF20FD@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 New TI LP55231 device has same I2C register layout as LP5523.
 Therefore, all of LED operations can be shared with the LP5523 driver.

 To support new LP55231 device explicitly, the device description
 is added in the configuration file.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 16578d3..0bc80bd 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -192,11 +192,12 @@ config LEDS_LP5521
 	  programming the engines.
 
 config LEDS_LP5523
-	tristate "LED Support for N.S. LP5523 LED driver chip"
+	tristate "LED Support for TI/National LP5523/55231 LED driver chip"
 	depends on LEDS_CLASS && I2C
 	help
-	  If you say yes here you get support for the National Semiconductor
-	  LP5523 LED driver. It is 9 channel chip with programmable engines.
+	  If you say yes here you get support for TI/National Semiconductor
+	  LP5523/55231 LED driver.
+	  It is 9 channel chip with programmable engines.
 	  Driver provides direct control via LED class and interface for
 	  programming the engines.
 
-- 
1.7.9.5


Best Regards,
Milo

