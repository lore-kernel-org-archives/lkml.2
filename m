Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab0IIWpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:45:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57182 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267Ab0IIWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q46mKiNB1ecHv6QkI7MzrCyfLjBk/qMjNrfzTbU5MqH747hUfs5GnTqucPHNCjoBTO
         Ufn+Uvv4u52lLrMadf22mtgkp1IaVUaxcrIrSuN9q1uV/ZviCxlFWVm7OWoHEL6uGCMz
         RuoKdcDfmtKxw701PK6PaW75EhzEWEJXewkcg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 206/223]drivers/usb/serial/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:45:05 -0700
Message-Id: <1284072309-8452-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
References: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/serial/Kconfig |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 916b2b6..de86d92 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -176,7 +176,7 @@ config USB_SERIAL_VISOR
 	help
 	  Say Y here if you want to connect to your HandSpring Visor, Palm
 	  m500 or m505 through its USB docking station. See
-	  <http://usbvisor.sourceforge.net/> for more information on using this
+	  <http://usbvisor.sourceforge.net/index.php3> for more information on using this
 	  driver.
 
 	  To compile this driver as a module, choose M here: the
@@ -264,7 +264,7 @@ config USB_SERIAL_IUU
 	help
 	  Say Y here if you want to use a IUU in phoenix mode and get
 	  an extra ttyUSBx device. More information available on
-	  http://eczema.ecze.com/iuu_phoenix.html
+	  http://www.opensc-project.org/openct/wiki/wbeiuu 
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called iuu_phoenix.o
@@ -289,8 +289,6 @@ config USB_SERIAL_KEYSPAN
 	  and was developed with their support.  You must also include
 	  firmware to support your particular device(s).
 
-	  See <http://misc.nu/hugh/keyspan.html> for more information.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called keyspan.
 
-- 
1.7.2.1

