Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1GGA2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:28:44 -0400
Received: from mail.perches.com ([173.55.12.10]:3633 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab1GGA2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:28:42 -0400
From: Joe Perches <joe@perches.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Michael Buesch <mb@bu3sch.de>
Subject: [PATCH next 1/2] MAINTAINERS: Update GPIO sections patterns
Date: Wed,  6 Jul 2011 17:28:39 -0700
Message-Id: <e9742e1fca57477517fdb6ea110221d6292eed9c.1309997525.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c103de24043 ("gpio: reorganize drivers")
renamed the files, update the patterns.

cc: Grant Likely <grant.likely@secretlab.ca>
cc: Michael Hennerich <michael.hennerich@analog.com>
cc: Michael Buesch <mb@bu3sch.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 657fabe..0ad8ff0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -343,7 +343,7 @@ S:	Supported
 F:	drivers/mfd/adp5520.c
 F:	drivers/video/backlight/adp5520_bl.c
 F:	drivers/leds/leds-adp5520.c
-F:	drivers/gpio/adp5520-gpio.c
+F:	drivers/gpio/gpio-adp5520.c
 F:	drivers/input/keyboard/adp5520-keys.c
 
 ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
@@ -352,7 +352,7 @@ L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP5588
 S:	Supported
 F:	drivers/input/keyboard/adp5588-keys.c
-F:	drivers/gpio/adp5588-gpio.c
+F:	drivers/gpio/gpio-adp5588.c
 
 ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
 M:	Michael Hennerich <michael.hennerich@analog.com>
@@ -1587,11 +1587,11 @@ S:	Maintained
 F:	Documentation/sound/alsa/Bt87x.txt
 F:	sound/pci/bt87x.c
 
-BT8XXGPIO DRIVER
+BT8XX GPIO DRIVER
 M:	Michael Buesch <mb@bu3sch.de>
 W:	http://bu3sch.de/btgpio.php
 S:	Maintained
-F:	drivers/gpio/bt8xxgpio.c
+F:	drivers/gpio/gpio-bt8xx.c
 
 BTRFS FILE SYSTEM
 M:	Chris Mason <chris.mason@oracle.com>
-- 
1.7.6.131.g99019

