Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab1CMK1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:35 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46240 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1CMK01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:27 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 24/24] staging: xgifb: clean up register function variable names
Date: Sun, 13 Mar 2011 12:26:28 +0200
Message-Id: <1300011988-2109-25-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate mixed case from variable names.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_util.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 19bcdab..a97e44f 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -23,30 +23,30 @@ u8 xgifb_reg_get(unsigned long port, u8 index)
 	return data;
 }
 
-void xgifb_reg_and_or(unsigned long Port, u8 Index,
-		unsigned DataAND, unsigned DataOR)
+void xgifb_reg_and_or(unsigned long port, u8 index,
+		unsigned data_and, unsigned data_or)
 {
 	u8 temp;
 
-	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
-	temp = (temp & (DataAND)) | DataOR;
-	xgifb_reg_set(Port, Index, temp);
+	temp = xgifb_reg_get(port, index); /* XGINew_Part1Port index 02 */
+	temp = (temp & data_and) | data_or;
+	xgifb_reg_set(port, index, temp);
 }
 
-void xgifb_reg_and(unsigned long Port, u8 Index, unsigned DataAND)
+void xgifb_reg_and(unsigned long port, u8 index, unsigned data_and)
 {
 	u8 temp;
 
-	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
-	temp &= DataAND;
-	xgifb_reg_set(Port, Index, temp);
+	temp = xgifb_reg_get(port, index); /* XGINew_Part1Port index 02 */
+	temp &= data_and;
+	xgifb_reg_set(port, index, temp);
 }
 
-void xgifb_reg_or(unsigned long Port, u8 Index, unsigned DataOR)
+void xgifb_reg_or(unsigned long port, u8 index, unsigned data_or)
 {
 	u8 temp;
 
-	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
-	temp |= DataOR;
-	xgifb_reg_set(Port, Index, temp);
+	temp = xgifb_reg_get(port, index); /* XGINew_Part1Port index 02 */
+	temp |= data_or;
+	xgifb_reg_set(port, index, temp);
 }
-- 
1.5.6.5

