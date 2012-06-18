Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2FRLNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:13:15 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:58049 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511Ab2FRLMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:12:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4CADoM309bdWObgWdsb2JhbABFhVewBCIBARYmJ4IZAQUjDwFGECUCJgICVwcSiA+lcpIFgSCKIIUggRIDlSSSX4FU
X-IronPort-AV: E=Sophos;i="4.77,430,1336341600"; 
   d="scan'208";a="1004339249"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 7/8] Staging: xgifb: Fix sparse warnings.
Date: Mon, 18 Jun 2012 13:12:05 +0200
Message-Id: <d3f4c36b93d1247bbd6697883e8acf12f1936098.1340016625.git.magomez@igalia.com>
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

Add include files with function definitions to avoid sparse warnings.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/vb_init.c    |    1 +
 drivers/staging/xgifb/vb_setmode.c |    2 +-
 drivers/staging/xgifb/vb_util.c    |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 64d1311..143957f 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -5,6 +5,7 @@
 #include "vb_def.h"
 #include "vb_util.h"
 #include "vb_setmode.h"
+#include "vb_init.h"
 static const unsigned short XGINew_DDRDRAM_TYPE340[4][2] = {
 	{ 16, 0x45},
 	{  8, 0x35},
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index b1713d3..479362e 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -4,7 +4,7 @@
 #include "vb_def.h"
 #include "vb_util.h"
 #include "vb_table.h"
-
+#include "vb_setmode.h"
 
 #define  IndexMask 0xff
 #define TVCLKBASE_315_25 (TVCLKBASE_315 + 25)
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 5c93a22..1b452f8 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -1,4 +1,5 @@
 #include "vgatypes.h"
+#include "vb_util.h"
 
 void xgifb_reg_set(unsigned long port, u8 index, u8 data)
 {
-- 
1.7.9.5

