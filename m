Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2F0UCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:02:21 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20242 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2F0UCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:02:20 -0400
Date: Wed, 27 Jun 2012 22:02:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        trivial@kernel.org, Forest Bond <forest@alittletooquiet.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] staging: vt6656: int.c: Use one space between variable
 type and name
In-Reply-To: <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206272201490.6908@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net> <20120625174709.GA3789@kroah.com> <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The style of most kernel code is that there is 1 *space* between the
type of a variable and its name. This patch enforces that in
drivers/staging/vt6656/int.c .

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/int.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index e7f6624..40605c8 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -90,8 +90,8 @@ void INTvWorkItem(void *Context)
 
 void INTnsProcessData(PSDevice pDevice)
 {
-	PSINTData	pINTData;
-	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
+	PSINTData pINTData;
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct net_device_stats *pStats = &pDevice->stats;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

