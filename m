Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0HPO0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:26:22 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54763 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0HPO0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:26:21 -0400
Date: Mon, 16 Aug 2010 16:26:08 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hid, Kconfig: Complete Kconfig prompt names
Message-ID: <20100816142607.GA2132@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make special HID devices' Kconfig names unambiguous, obviating the need
to enter the help menu of each driver in order to know what hardware
device it actually supports.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "Bruno Prémont" <bonbons@linux-vserver.org>
Cc: Stephane Chatty <chatty@enac.fr>
Cc: Don Prince <dhprince-devel@yahoo.co.uk>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/hid/Kconfig |   60 +++++++++++++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 6369ba7..2072e01 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -56,20 +56,20 @@ menu "Special HID drivers"
 	depends on HID
 
 config HID_3M_PCT
-	tristate "3M PCT"
+	tristate "3M PCT touchscreen"
 	depends on USB_HID
 	---help---
 	Support for 3M PCT touch screens.
 
 config HID_A4TECH
-	tristate "A4 tech" if EMBEDDED
+	tristate "A4 tech mice" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
 
 config HID_ACRUX_FF
-	tristate "ACRUX force feedback support"
+	tristate "ACRUX force feedback"
 	depends on USB_HID
 	select INPUT_FF_MEMLESS
 	---help---
@@ -77,7 +77,7 @@ config HID_ACRUX_FF
 	game controllers.
 
 config HID_APPLE
-	tristate "Apple" if EMBEDDED
+	tristate "Apple {i,Power,Mac}Books" if EMBEDDED
 	depends on (USB_HID || BT_HIDP)
 	default !EMBEDDED
 	---help---
@@ -88,7 +88,7 @@ config HID_APPLE
 	MacBooks, MacBook Pros and Apple Aluminum.
 
 config HID_BELKIN
-	tristate "Belkin" if EMBEDDED
+	tristate "Belkin Flip KVM and Wireless keyboard" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
@@ -101,14 +101,14 @@ config HID_CANDO
 	Support for Cando dual touch panel.
 
 config HID_CHERRY
-	tristate "Cherry" if EMBEDDED
+	tristate "Cherry Cymotion keyboard" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Cherry Cymotion keyboard.
 
 config HID_CHICONY
-	tristate "Chicony" if EMBEDDED
+	tristate "Chicony Tactical pad" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
@@ -130,20 +130,20 @@ config HID_PRODIKEYS
 	  and some additional multimedia keys.
 
 config HID_CYPRESS
-	tristate "Cypress" if EMBEDDED
+	tristate "Cypress mouse and barcode readers" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for cypress mouse and barcode readers.
 
 config HID_DRAGONRISE
-	tristate "DragonRise Inc. support"
+	tristate "DragonRise Inc. game controller"
 	depends on USB_HID
 	---help---
 	Say Y here if you have DragonRise Inc.game controllers.
 
 config DRAGONRISE_FF
-	bool "DragonRise Inc. force feedback support"
+	bool "DragonRise Inc. force feedback"
 	depends on HID_DRAGONRISE
 	select INPUT_FF_MEMLESS
 	---help---
@@ -157,46 +157,46 @@ config HID_EGALAX
 	Support for the eGalax dual-touch panel.
 
 config HID_ELECOM
-	tristate "ELECOM"
+	tristate "ELECOM BM084 bluetooth mouse"
 	depends on BT_HIDP
 	---help---
 	Support for the ELECOM BM084 (bluetooth mouse).
 
 config HID_EZKEY
-	tristate "Ezkey" if EMBEDDED
+	tristate "Ezkey BTC 8193 keyboard" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Ezkey BTC 8193 keyboard.
 
 config HID_KYE
-	tristate "Kye" if EMBEDDED
+	tristate "Kye/Genius Ergo Mouse" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Kye/Genius Ergo Mouse.
 
 config HID_GYRATION
-	tristate "Gyration"
+	tristate "Gyration remote control"
 	depends on USB_HID
 	---help---
 	Support for Gyration remote control.
 
 config HID_TWINHAN
-	tristate "Twinhan"
+	tristate "Twinhan IR remote control"
 	depends on USB_HID
 	---help---
 	Support for Twinhan IR remote control.
 
 config HID_KENSINGTON
-	tristate "Kensington" if EMBEDDED
+	tristate "Kensington Slimblade Trackball" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Kensington Slimblade Trackball.
 
 config HID_LOGITECH
-	tristate "Logitech" if EMBEDDED
+	tristate "Logitech devices" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
@@ -245,39 +245,39 @@ config HID_MAGICMOUSE
 	Apple Wireless "Magic" Mouse.
 
 config HID_MICROSOFT
-	tristate "Microsoft" if EMBEDDED
+	tristate "Microsoft non-fully HID-compliant devices" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Microsoft devices that are not fully compliant with HID standard.
 
 config HID_MOSART
-	tristate "MosArt"
+	tristate "MosArt dual-touch panels"
 	depends on USB_HID
 	---help---
 	Support for MosArt dual-touch panels.
 
 config HID_MONTEREY
-	tristate "Monterey" if EMBEDDED
+	tristate "Monterey Genius KB29E keyboard" if EMBEDDED
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Monterey Genius KB29E.
 
 config HID_NTRIG
-	tristate "NTrig"
+	tristate "N-Trig touch screen"
 	depends on USB_HID
 	---help---
 	Support for N-Trig touch screen.
 
 config HID_ORTEK
-	tristate "Ortek"
+	tristate "Ortek WKB-2000 wireless keyboard and mouse trackpad"
 	depends on USB_HID
 	---help---
 	Support for Ortek WKB-2000 wireless keyboard + mouse trackpad.
 
 config HID_PANTHERLORD
-	tristate "Pantherlord support"
+	tristate "Pantherlord/GreenAsia game controller"
 	depends on USB_HID
 	---help---
 	  Say Y here if you have a PantherLord/GreenAsia based game controller
@@ -292,7 +292,7 @@ config PANTHERLORD_FF
 	  or adapter and want to enable force feedback support for it.
 
 config HID_PETALYNX
-	tristate "Petalynx"
+	tristate "Petalynx Maxter remote control"
 	depends on USB_HID
 	---help---
 	Support for Petalynx Maxter remote control.
@@ -356,7 +356,7 @@ config HID_PICOLCD_LEDS
 	  Provide access to PicoLCD's GPO pins via leds class.
 
 config HID_QUANTA
-	tristate "Quanta Optical Touch"
+	tristate "Quanta Optical Touch panels"
 	depends on USB_HID
 	---help---
 	Support for Quanta Optical Touch dual-touch panels.
@@ -377,31 +377,31 @@ config HID_ROCCAT_KONE
 	Support for Roccat Kone mouse.
 
 config HID_SAMSUNG
-	tristate "Samsung"
+	tristate "Samsung InfraRed remote control or keyboards"
 	depends on USB_HID
 	---help---
 	Support for Samsung InfraRed remote control or keyboards.
 
 config HID_SONY
-	tristate "Sony"
+	tristate "Sony PS3 controller"
 	depends on USB_HID
 	---help---
 	Support for Sony PS3 controller.
 
 config HID_STANTUM
-	tristate "Stantum"
+	tristate "Stantum multitouch panel"
 	depends on USB_HID
 	---help---
 	Support for Stantum multitouch panel.
 
 config HID_SUNPLUS
-	tristate "Sunplus"
+	tristate "Sunplus wireless desktop"
 	depends on USB_HID
 	---help---
 	Support for Sunplus wireless desktop.
 
 config HID_GREENASIA
-	tristate "GreenAsia (Product ID 0x12) support"
+	tristate "GreenAsia (Product ID 0x12) game controller support"
 	depends on USB_HID
 	---help---
 	  Say Y here if you have a GreenAsia (Product ID 0x12) based game
-- 
1.7.1

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
