Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab0IIWrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:47:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51373 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933209Ab0IIWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=L7iDGJqg5UW1Q4t97pUp2fT3mEhNndrYFZ2UuREE5MoTKP/tSTLaTNLIj4EOijpivh
         PQAoCsGQmfVnicpDASkxvdrFZ/WEMviFI3W/7haMGqvKwSKXTBFnPd7dhIGilOcLZlpS
         P4VCNBp/8mTec46wyd4XZZYo1BoFb6/vFTcjk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 217/223]drivers/video/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:46:01 -0700
Message-Id: <1284072367-8485-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072367-8485-1-git-send-email-justinmattock@gmail.com>
References: <1284072367-8485-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/video/Kconfig |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 8b31fdf..a15a092 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -49,7 +49,7 @@ menuconfig FB
 	  You need an utility program called fbset to make full use of frame
 	  buffer devices. Please read <file:Documentation/fb/framebuffer.txt>
 	  and the Framebuffer-HOWTO at
-	  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.2.html> for more
+	  <http://www.faqs.org/docs/Linux-HOWTO/Framebuffer-HOWTO.html> for more
 	  information.
 
 	  Say Y here and to the driver for your graphics board below if you
@@ -955,7 +955,7 @@ config FB_EPSON1355
 	  Build in support for the SED1355 Epson Research Embedded RAMDAC
 	  LCD/CRT Controller (since redesignated as the S1D13505) as a
 	  framebuffer.  Product specs at
-	  <http://www.erd.epson.com/vdc/html/products.htm>.
+	  <http://www.erd.epson.com/>.
 
 config FB_S1D13XXX
 	tristate "Epson S1D13XXX framebuffer support"
@@ -966,7 +966,7 @@ config FB_S1D13XXX
 	help
 	  Support for S1D13XXX framebuffer device family (currently only
 	  working with S1D13806). Product specs at
-	  <http://www.erd.epson.com/vdc/html/legacy_13xxx.htm>
+	  <http://www.erd.epson.com/>
 
 config FB_ATMEL
 	tristate "AT91/AT32 LCD Controller support"
@@ -1323,7 +1323,7 @@ config FB_RADEON
 	  don't need to choose this to run the Radeon in plain VGA mode.
 
 	  There is a product page at
-	  http://apps.ati.com/ATIcompare/
+	  http://www.amd.com/us/products/technologies/ati-catalyst/Pages/catalyst.aspx 
 
 config FB_RADEON_I2C
 	bool "DDC/I2C for ATI Radeon support"
@@ -1395,7 +1395,7 @@ config FB_ATY_CT
 	  Say Y here to support use of ATI's 64-bit Rage boards (or other
 	  boards based on the Mach64 CT, VT, GT, and LT chipsets) as a
 	  framebuffer device.  The ATI product support page for these boards
-	  is at <http://support.ati.com/products/pc/mach64/>.
+	  is at <http://www.amd.com/us/products/technologies/ati-catalyst/Pages/catalyst.aspx>.
 
 config FB_ATY_GENERIC_LCD
 	bool "Mach64 generic LCD support (EXPERIMENTAL)"
-- 
1.7.2.1

