Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1GEWVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:21:38 -0400
Received: from mail.perches.com ([173.55.12.10]:3602 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1GEWVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:21:37 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: =?UTF-8?q?=5BPATCH=5D=20MAINTAINERS=3A=20Add=20remaining=20staging=20entries?=
Date: Tue,  5 Jul 2011 15:21:34 -0700
Message-Id: <baddeef1d7f9a0d60077ecea123aca2fd2066b04.1309904318.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the staging entries from various TODO files
to MAINTAINERS.  Add a few web links as well.

Miscellaneous staging typo section header fix.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 68 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c11854..c9a9908 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6080,6 +6080,12 @@ M:	Jakub Schmidtke <sjakub@gmail.com>
 S:	Odd Fixes
 F:	drivers/staging/asus_oled/
 
+STAGING - ATHEROS ATH6KL WIRELESS DRIVER
+M:	Luis R. Rodriguez <mcgrof@gmail.com>
+M:	Naveen Singh <nsingh@atheros.com>
+S:	Odd Fixes
+F:	drivers/staging/ath6kl/
+
 STAGING - COMEDI
 M:	Ian Abbott <abbotti@mev.co.uk>
 M:	Mori Hess <fmhess@users.sourceforge.net>
@@ -6094,12 +6100,22 @@ M:	Manu Abraham <abraham.manu@gmail.com>
 S:	Odd Fixes
 F:	drivers/staging/crystalhd/
 
+STAGING - CYPRESS WESTBRIDGE SUPPORT
+M:	David Cross <david.cross@cypress.com>
+S:	Odd Fixes
+F:	drivers/staging/westbridge/
+
 STAGING - ECHO CANCELLER
 M:	Steve Underwood <steveu@coppice.org>
 M:	David Rowe <david@rowetel.com>
 S:	Odd Fixes
 F:	drivers/staging/echo/
 
+STAGING - FLARION FT1000 DRIVERS
+M:	Marek Belisko <marek.belisko@gmail.com>
+S:	Odd Fixes
+F:	drivers/staging/ft1000/
+
 STAGING - FRONTIER TRANZPORT AND ALPHATRACK
 M:	David Täht <d@teklibre.com>
 S:	Odd Fixes
@@ -6113,19 +6129,70 @@ F:	drivers/staging/hv/
 
 STAGING - INDUSTRIAL IO
 M:	Jonathan Cameron <jic23@cam.ac.uk>
+L:	linux-iio@vger.kernel.org
 S:	Odd Fixes
 F:	drivers/staging/iio/
 
-STAGING -  PARALLEL LCD/KEYPAD PANEL DRIVER
+STAGING - LIRC (LINUX INFRARED REMOTE CONTROL) DRIVERS
+M:	Jarod Wilson <jarod@wilsonet.com>
+W:	http://www.lirc.org/
+S:	Odd Fixes
+F:	drivers/staging/lirc/
+
+STAGING - OLPC SECONDARY DISPLAY CONTROLLER (DCON)
+M:	Andres Salomon <dilinger@queued.net>
+M:	Chris Ball <cjb@laptop.org>
+M:	Jon Nettleton <jon.nettleton@gmail.com>
+W:	http://wiki.laptop.org/go/DCON
+S:	Odd Fixes
+F:	drivers/staging/olpc_dcon/
+
+STAGING - PARALLEL LCD/KEYPAD PANEL DRIVER
 M:	Willy Tarreau <willy@meta-x.org>
 S:	Odd Fixes
 F:	drivers/staging/panel/
 
+STAGING - REALTEK RTL8712U DRIVERS
+M:	Larry Finger <Larry.Finger@lwfinger.net>
+M:	Florian Schilhabel <florian.c.schilhabel@googlemail.com>.
+S:	Odd Fixes
+F:	drivers/staging/rtl8712/
+
 STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
 M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
 S:	Odd Fixes
 F:	drivers/staging/sm7xx/
 
+STAGING - SOFTLOGIC 6x10 MPEG CODEC
+M:	Ben Collins <bcollins@bluecherry.net>
+S:	Odd Fixes
+F:	drivers/staging/solo6x10/
+
+STAGING - SPEAKUP CONSOLE SPEECH DRIVER
+M:	William Hubbs <w.d.hubbs@gmail.com>
+M:	Chris Brannon <chris@the-brannons.com>
+M:	Kirk Reiser <kirk@braille.uwo.ca>
+M:	Samuel Thibault <samuel.thibault@ens-lyon.org>
+L:	speakup@braille.uwo.ca
+W:	http://www.linux-speakup.org/
+S:	Odd Fixes
+F:	drivers/staging/speakup/
+
+STAGING - TI DSP BRIDGE DRIVERS
+M:	Omar Ramirez Luna <omar.ramirez@ti.com>
+S:	Odd Fixes
+F:	drivers/staging/tidspbridge/
+
+STAGING - TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/staging/tm6000/
+
+STAGING - USB ENE SM/MS CARD READER DRIVER
+M:	Al Cho <acho@novell.com>
+S:	Odd Fixes
+F:	drivers/staging/keucr/
+
 STAGING - VIA VT665X DRIVERS
 M:	Forest Bond <forest@alittletooquiet.net>
 S:	Odd Fixes
-- 
1.7.6.131.g99019

