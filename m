Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1HSTmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:42:51 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:59629 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab1HSTka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:30 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] staging: xgifb: eliminate XGIINITSTATIC
Date: Fri, 19 Aug 2011 22:40:20 +0300
Message-Id: <1313782830-31461-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XGIINITSTATIC can be replace simply with "static".

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    1 -
 drivers/staging/xgifb/XGI_main_26.c |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index f6cd22d..09a35fd 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -41,7 +41,6 @@
 
 #define XGI_IOTYPE1 void __iomem
 #define XGI_IOTYPE2 __iomem
-#define XGIINITSTATIC static
 
 static DEFINE_PCI_DEVICE_TABLE(xgifb_pci_table) = {
 	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 4403e5f..8a19a7d 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1949,7 +1949,7 @@ static void XGIfb_get_VB_type(void)
 	}
 }
 
-XGIINITSTATIC int __init XGIfb_setup(char *options)
+static int __init XGIfb_setup(char *options)
 {
 	char *this_opt;
 
@@ -2543,7 +2543,7 @@ static struct pci_driver xgifb_driver = {
 	.remove = __devexit_p(xgifb_remove)
 };
 
-XGIINITSTATIC int __init xgifb_init(void)
+static int __init xgifb_init(void)
 {
 	char *option = NULL;
 
-- 
1.7.2.5

