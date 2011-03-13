Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab1CMK1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:11 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39913 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab1CMK0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:23 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 12/24] staging: xgifb: vb_util: include the .h file
Date: Sun, 13 Mar 2011 12:26:16 +0200
Message-Id: <1300011988-2109-13-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the .h file and delete redundant definitions.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_util.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 65b3954..f542d66 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -6,20 +6,7 @@
 #include <asm/io.h>
 #include <linux/types.h>
 
-void XGINew_SetReg1(unsigned long, unsigned short, unsigned short);
-void XGINew_SetReg2(unsigned long, unsigned short, unsigned short);
-void XGINew_SetReg3(unsigned long, unsigned short);
-void XGINew_SetReg4(unsigned long, unsigned long);
-unsigned char XGINew_GetReg1(unsigned long, unsigned short);
-unsigned char XGINew_GetReg2(unsigned long);
-unsigned long XGINew_GetReg3(unsigned long);
-void XGINew_ClearDAC(unsigned char *);
-void XGINew_SetRegANDOR(unsigned long Port, unsigned short Index,
-		unsigned short DataAND, unsigned short DataOR);
-void XGINew_SetRegOR(unsigned long Port, unsigned short Index,
-		unsigned short DataOR);
-void XGINew_SetRegAND(unsigned long Port, unsigned short Index,
-		unsigned short DataAND);
+#include "vb_util.h"
 
 /* --------------------------------------------------------------------- */
 /* Function : XGINew_SetReg1 */
-- 
1.5.6.5

