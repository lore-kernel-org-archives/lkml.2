Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2H1WQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:16:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:51578 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab2H1WQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:16:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,330,1344236400"; 
   d="scan'208";a="185992850"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: add lynx point pci device ids
Date: Wed, 29 Aug 2012 01:15:50 +0300
Message-Id: <1346192150-27400-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw.h   |    2 ++
 drivers/misc/mei/main.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index b3b4c6d..9700532 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -80,6 +80,8 @@
 #define MEI_DEV_ID_PPT_2      0x1CBA  /* Panther Point */
 #define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
 
+#define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
+#define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index d6fe278..ae2cd0d 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -77,6 +77,8 @@ static DEFINE_PCI_DEVICE_TABLE(mei_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_1)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_2)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_3)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_LP)},
 
 	/* required last entry */
 	{0, }
-- 
1.7.4.4

