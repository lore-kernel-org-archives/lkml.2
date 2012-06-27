Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2F0UAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:00:16 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20091 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2F0UAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:00:15 -0400
Date: Wed, 27 Jun 2012 22:00:14 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        trivial@kernel.org, Forest Bond <forest@alittletooquiet.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] staging: vt6656: int: Redundant blank line removal
In-Reply-To: <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206272159510.6908@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net> <20120625174709.GA3789@kroah.com> <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial cleanup patch removes some completely redundant blank
lines from drivers/staging/vt6656/int.[ch]

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/int.c | 4 ----
 drivers/staging/vt6656/int.h | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 0a11423..36ed234 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -44,7 +44,6 @@
 /* static int msglevel = MSG_LEVEL_DEBUG; */
 static int msglevel = MSG_LEVEL_INFO;
 
-
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
@@ -53,10 +52,8 @@ static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Export Variables  --------------------------*/
 
-
 /*---------------------  Export Functions  --------------------------*/
 
-
 /*+
  *
  *  Function:   InterruptPollingThread
@@ -202,7 +199,6 @@ void INTnsProcessData(PSDevice pDevice)
 					pINTData->byISR0,
 					pINTData->byISR1);
 	}
-
 	if (pINTData->byISR1 != 0)
 		if (pINTData->byISR1 & ISR_GPIO3)
 			bScheduleCommand((void *) pDevice,
diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index a5d96b9..3098630 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -60,7 +60,6 @@ typedef struct tagSINTData {
 } __attribute__ ((__packed__))
 SINTData, *PSINTData;
 
-
 /*---------------------  Export Classes  ----------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

