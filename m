Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab2F0UDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:03:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20315 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab2F0UDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:03:31 -0400
Date: Wed, 27 Jun 2012 22:03:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        trivial@kernel.org, Forest Bond <forest@alittletooquiet.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] staging: vt6656: int.c: correct indentation to use tabs
 rather than spaces
In-Reply-To: <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206272202510.6908@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net> <20120625174709.GA3789@kroah.com> <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/int.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index e9fab45..eba4b50 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -182,11 +182,11 @@ void INTnsProcessData(PSDevice pDevice)
 		LODWORD(pDevice->qwCurrTSF) = pINTData->dwLoTSF;
 		HIDWORD(pDevice->qwCurrTSF) = pINTData->dwHiTSF;
 		/*DBG_PRN_GRP01(("ISR0 = %02x ,
-				LoTsf =  %08x,
-				HiTsf =  %08x\n",
-				pINTData->byISR0,
-				pINTData->dwLoTSF,
-				pINTData->dwHiTSF)); */
+		  LoTsf =  %08x,
+		  HiTsf =  %08x\n",
+		  pINTData->byISR0,
+		  pINTData->dwLoTSF,
+		  pINTData->dwHiTSF)); */
 
 		STAvUpdate802_11Counter(&pDevice->s802_11Counter,
 					&pDevice->scStatistic,
@@ -208,8 +208,8 @@ void INTnsProcessData(PSDevice pDevice)
 
 	pStats->tx_packets = pDevice->scStatistic.ullTsrOK;
 	pStats->tx_bytes = pDevice->scStatistic.ullTxDirectedBytes +
-			pDevice->scStatistic.ullTxMulticastBytes +
-			pDevice->scStatistic.ullTxBroadcastBytes;
+		pDevice->scStatistic.ullTxMulticastBytes +
+		pDevice->scStatistic.ullTxBroadcastBytes;
 	pStats->tx_errors = pDevice->scStatistic.dwTsrErr;
 	pStats->tx_dropped = pDevice->scStatistic.dwTsrErr;
 }
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

