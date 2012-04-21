Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2DUUFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 16:05:20 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21451 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2DUUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 16:04:46 -0400
Date: Sat, 21 Apr 2012 22:04:45 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: trivial@kernel.org, devel@driverdev.osuosl.org,
        Xi Wang <xi.wang@gmail.com>, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH 3/3] staging: vt6656: trivial whitespace cleanups to
 ioctl.c
In-Reply-To: <alpine.LNX.2.00.1204212156260.25551@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204212203320.25551@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204212156260.25551@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a space between a cast and the variable and makes the
case statements in the switch stylewise consistent as to whether
there's a blank line before each 'case' or not.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index deea69b..4f29778 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -149,6 +149,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			}
 		}
 		break;
+
 	case WLAN_CMD_BSS_JOIN:
 		if (copy_from_user(&sJoinCmd, pReq->data, sizeof(SCmdBSSJoin))) {
 			result = -EFAULT;
@@ -311,7 +312,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 				pList->sBSSIDList[ii].wBeaconInterval = pBSS->wBeaconInterval;
 				pList->sBSSIDList[ii].wCapInfo = pBSS->wCapInfo;
 				RFvRSSITodBm(pDevice, (BYTE)(pBSS->uRSSI), &ldBm);
-				pList->sBSSIDList[ii].uRSSI = (unsigned int) ldBm;
+				pList->sBSSIDList[ii].uRSSI = (unsigned int)ldBm;
 				/* pList->sBSSIDList[ii].uRSSI = pBSS->uRSSI; */
 				memcpy(pList->sBSSIDList[ii].abyBSSID, pBSS->abyBSSID, WLAN_BSSID_LEN);
 				pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
@@ -354,6 +355,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			break;
 		}
 		break;
+
 	case WLAN_CMD_STOP_MAC:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_STOP_MAC\n");
 		/* Todo xxxxxx */
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

