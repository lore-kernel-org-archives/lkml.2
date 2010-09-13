Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0IMImD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:42:03 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64767 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab0IMIlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MMNfxgNk4/7cTgqLD8Rn05en6/Ikt/wJ0yv5OBrHnm1UT2kctzuW4pVfD/DqqV1Urc
         G2Akt8ciXTx3V9ZikLTabrzwBq9WsP/t7XJ/JA43XIjcj17M9rCl7JZlJ3EwvkdnsLc2
         qUOP90kBcKD988r7Tl50HkmTIexpgicDjGo8I=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 07/10] staging: rt2870: use '%pM' format to print MAC address
Date: Mon, 13 Sep 2010 11:40:31 +0300
Message-Id: <22619132d277a8208ee64a953b627507c575bbc2.1284316739.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/rt2870/common/rtusb_io.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rt2870/common/rtusb_io.c b/drivers/staging/rt2870/common/rtusb_io.c
index 6b9ca24..7d2f7e0 100644
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -1879,13 +1879,10 @@ void CMDHandler(struct rt_rtmp_adapter *pAd)
 					AsicUpdateRxWCIDTable(pAd, pEntry->Aid,
 							      pEntry->Addr);
 					DBGPRINT(RT_DEBUG_TRACE,
-						 ("UpdateRxWCIDTable(): Aid=%d, Addr=%02x:%02x:%02x:%02x:%02x:%02x!\n",
-						  pEntry->Aid, pEntry->Addr[0],
-						  pEntry->Addr[1],
-						  pEntry->Addr[2],
-						  pEntry->Addr[3],
-						  pEntry->Addr[4],
-						  pEntry->Addr[5]));
+						("UpdateRxWCIDTable(): Aid=%d, "
+							"Addr=%pM!\n",
+							pEntry->Aid,
+							pEntry->Addr));
 				}
 				break;
 
-- 
1.7.2.2

