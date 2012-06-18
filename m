Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab2FRLOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:14:46 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56246 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906Ab2FRLMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:12:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4CADoM309bdWObgWdsb2JhbABFhVewBCIBARYmJ4IZAQUjDwFGECUCJgICVwcSiA+lcpIFgSCPQIESA5Ukkl8
X-IronPort-AV: E=Sophos;i="4.77,430,1336341600"; 
   d="scan'208";a="1004339230"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 1/8] Staging: xgifb: reformat module parameter descriptions.
Date: Mon, 18 Jun 2012 13:11:59 +0200
Message-Id: <1031dc5d561c9b8b9f518a09d9b99ed15a7934a4.1340016625.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 3382272..8e0786d 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2297,23 +2297,23 @@ static struct pci_driver xgifb_driver = {
 
 module_param(mode, charp, 0);
 MODULE_PARM_DESC(mode,
-	"\nSelects the desired default display mode in the format XxYxDepth,\n"
-	"eg. 1024x768x16.\n");
+	"Selects the desired default display mode in the format XxYxDepth "
+	"(eg. 1024x768x16).");
 
 module_param(forcecrt2type, charp, 0);
 MODULE_PARM_DESC(forcecrt2type,
-	"\nForce the second display output type. Possible values are NONE,\n"
-	"LCD, TV, VGA, SVIDEO or COMPOSITE.\n");
+	"Force the second display output type. Possible values are NONE, "
+	"LCD, TV, VGA, SVIDEO or COMPOSITE.");
 
 module_param(vesa, int, 0);
 MODULE_PARM_DESC(vesa,
-	"\nSelects the desired default display mode by VESA mode number, eg.\n"
-	"0x117.\n");
+	"Selects the desired default display mode by VESA mode number "
+	"(eg. 0x117).");
 
 module_param(filter, int, 0);
 MODULE_PARM_DESC(filter,
-	"\nSelects TV flicker filter type (only for systems with a SiS301 video bridge).\n"
-	"(Possible values 0-7, default: [no filter])\n");
+	"Selects TV flicker filter type (only for systems with a SiS301 video bridge). "
+	"Possible values 0-7. Default: [no filter]).");
 
 static int __init xgifb_init(void)
 {
-- 
1.7.9.5

