Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2FMWWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:22:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43735 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753229Ab2FMWWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:02 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1//9YYgvN7/ER1ZhH7OVvmyTe3apdcOhpCGb239yG
	hPSdKLiALOyoZC
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] staging/xgifb: Add header #include guards to vb_table.h
Date: Thu, 14 Jun 2012 00:21:41 +0200
Message-Id: <1339626112-20671-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a simple #include guard to vb_table.h

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_table.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index d22e599..9a17113 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -1,3 +1,5 @@
+#ifndef _VB_TABLE_
+#define _VB_TABLE_
 /* yilin modify for xgi20 */
 static struct SiS_MCLKData XGI340New_MCLKData[] = {
 	{0x16, 0x01, 0x01, 166},
@@ -2696,3 +2698,4 @@ static struct XGI301C_Tap4TimingStruct YPbPr750pTap4Timing[] = {
 		 }
 	}
 };
+#endif
-- 
1.7.3.4

