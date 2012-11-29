Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2K2INO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:13:14 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:32936 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab2K2INM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:13:12 -0500
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net
Subject: [PATCH 01/11] platform-drivers-x86: change my mail
Date: Thu, 29 Nov 2012 09:12:29 +0100
Message-Id: <1354176759-630-2-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1354176759-630-1-git-send-email-corentin.chary@gmail.com>
References: <1354176759-630-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 MAINTAINERS                        |    4 ++--
 drivers/platform/x86/asus-nb-wmi.c |    2 +-
 drivers/platform/x86/asus-wmi.c    |    2 +-
 drivers/platform/x86/eeepc-wmi.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 656a8b0..f5ea7c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1278,7 +1278,7 @@ F:	Documentation/hwmon/asc7621
 F:	drivers/hwmon/asc7621.c
 
 ASUS NOTEBOOKS AND EEEPC ACPI/WMI EXTRAS DRIVERS
-M:	Corentin Chary <corentincj@iksaif.net>
+M:	Corentin Chary <corentin.chary@gmail.com>
 L:	acpi4asus-user@lists.sourceforge.net
 L:	platform-driver-x86@vger.kernel.org
 W:	http://acpi4asus.sf.net
@@ -6471,7 +6471,7 @@ F:	drivers/media/pci/saa7146/
 F:	include/media/saa7146*
 
 SAMSUNG LAPTOP DRIVER
-M:	Corentin Chary <corentincj@iksaif.net>
+M:	Corentin Chary <corentin.chary@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/samsung-laptop.c
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 6b0ebde..be79040 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -32,7 +32,7 @@
 
 #define	ASUS_NB_WMI_FILE	"asus-nb-wmi"
 
-MODULE_AUTHOR("Corentin Chary <corentincj@iksaif.net>");
+MODULE_AUTHOR("Corentin Chary <corentin.chary@gmail.com>");
 MODULE_DESCRIPTION("Asus Notebooks WMI Hotkey Driver");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 18f5169..912ec7d 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -51,7 +51,7 @@
 
 #include "asus-wmi.h"
 
-MODULE_AUTHOR("Corentin Chary <corentincj@iksaif.net>, "
+MODULE_AUTHOR("Corentin Chary <corentin.chary@gmail.com>, "
 	      "Yong Wang <yong.y.wang@intel.com>");
 MODULE_DESCRIPTION("Asus Generic WMI Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 5838332..60cb76a 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -39,7 +39,7 @@
 
 #define	EEEPC_WMI_FILE	"eeepc-wmi"
 
-MODULE_AUTHOR("Corentin Chary <corentincj@iksaif.net>");
+MODULE_AUTHOR("Corentin Chary <corentin.chary@gmail.com>");
 MODULE_DESCRIPTION("Eee PC WMI Hotkey Driver");
 MODULE_LICENSE("GPL");
 
-- 
1.7.8.6

