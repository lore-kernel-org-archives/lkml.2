Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2F0UCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:02:50 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20278 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab2F0UCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:02:49 -0400
Date: Wed, 27 Jun 2012 22:02:48 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        trivial@kernel.org, Forest Bond <forest@alittletooquiet.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] staging: vt6656: int.c: We don't use spaces between a
 cast and the variable being converted
In-Reply-To: <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206272202220.6908@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net> <20120625174709.GA3789@kroah.com> <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove spaces between casts and variables from
drivers/staging/vt6656/int.c .

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/int.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 40605c8..e9fab45 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -99,8 +99,8 @@ void INTnsProcessData(PSDevice pDevice)
 	pINTData = (PSINTData) pDevice->intBuf.pDataBuf;
 	if (pINTData->byTSR0 & TSR_VALID) {
 		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(BYTE) (pINTData->byPkt0 & 0x0F),
-					(BYTE) (pINTData->byPkt0>>4),
+					(BYTE)(pINTData->byPkt0 & 0x0F),
+					(BYTE)(pINTData->byPkt0>>4),
 					pINTData->byTSR0);
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
@@ -110,8 +110,8 @@ void INTnsProcessData(PSDevice pDevice)
 	}
 	if (pINTData->byTSR1 & TSR_VALID) {
 		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(BYTE) (pINTData->byPkt1 & 0x0F),
-					(BYTE) (pINTData->byPkt1>>4),
+					(BYTE)(pINTData->byPkt1 & 0x0F),
+					(BYTE)(pINTData->byPkt1>>4),
 					pINTData->byTSR1);
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
@@ -121,8 +121,8 @@ void INTnsProcessData(PSDevice pDevice)
 	}
 	if (pINTData->byTSR2 & TSR_VALID) {
 		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(BYTE) (pINTData->byPkt2 & 0x0F),
-					(BYTE) (pINTData->byPkt2>>4),
+					(BYTE)(pINTData->byPkt2 & 0x0F),
+					(BYTE)(pINTData->byPkt2>>4),
 					pINTData->byTSR2);
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
@@ -132,8 +132,8 @@ void INTnsProcessData(PSDevice pDevice)
 	}
 	if (pINTData->byTSR3 & TSR_VALID) {
 		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(BYTE) (pINTData->byPkt3 & 0x0F),
-					(BYTE) (pINTData->byPkt3>>4),
+					(BYTE)(pINTData->byPkt3 & 0x0F),
+					(BYTE)(pINTData->byPkt3>>4),
 					pINTData->byTSR3);
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

