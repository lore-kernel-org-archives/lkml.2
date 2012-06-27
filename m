Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2F0UAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:00:44 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20130 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2F0UAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:00:43 -0400
Date: Wed, 27 Jun 2012 22:00:41 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        trivial@kernel.org, Forest Bond <forest@alittletooquiet.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] staging: vt6656: int.h: Fix indentation and spacing
In-Reply-To: <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206272200200.6908@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net> <20120625174709.GA3789@kroah.com> <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use tabs for indentation and once space between variable types and
variable name.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/int.h | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index 3098630..3734e2c 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -36,27 +36,27 @@
 /*---------------------  Export Definitions -------------------------*/
 #pragma pack(1)
 typedef struct tagSINTData {
-    BYTE    byTSR0;
-    BYTE    byPkt0;
-    WORD    wTime0;
-    BYTE    byTSR1;
-    BYTE    byPkt1;
-    WORD    wTime1;
-    BYTE    byTSR2;
-    BYTE    byPkt2;
-    WORD    wTime2;
-    BYTE    byTSR3;
-    BYTE    byPkt3;
-    WORD    wTime3;
-    DWORD   dwLoTSF;
-    DWORD   dwHiTSF;
-    BYTE    byISR0;
-    BYTE    byISR1;
-    BYTE    byRTSSuccess;
-    BYTE    byRTSFail;
-    BYTE    byACKFail;
-    BYTE    byFCSErr;
-    BYTE    abySW[2];
+	BYTE byTSR0;
+	BYTE byPkt0;
+	WORD wTime0;
+	BYTE byTSR1;
+	BYTE byPkt1;
+	WORD wTime1;
+	BYTE byTSR2;
+	BYTE byPkt2;
+	WORD wTime2;
+	BYTE byTSR3;
+	BYTE byPkt3;
+	WORD wTime3;
+	DWORD dwLoTSF;
+	DWORD dwHiTSF;
+	BYTE byISR0;
+	BYTE byISR1;
+	BYTE byRTSSuccess;
+	BYTE byRTSFail;
+	BYTE byACKFail;
+	BYTE byFCSErr;
+	BYTE abySW[2];
 } __attribute__ ((__packed__))
 SINTData, *PSINTData;
 
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

