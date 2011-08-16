Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1HPA0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:26:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34115 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1HPA0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:26:03 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Akshay Joshi <me@akshayjoshi.com>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] Staging: Winbond: Reposition a curly bracket.
Date: Mon, 15 Aug 2011 20:24:35 -0400
Message-Id: <1313454275-5604-9-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The curly bracket preceding the body of a conditional statement should
be on the same line as the conditional statement according to the
kernel's coding style.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/wb35tx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index a06212a..20bf966 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -138,8 +138,7 @@ unsigned char Wb35Tx_initial(struct hw_data *pHwData)
 		return false;
 
 	pWb35Tx->Tx2Urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!pWb35Tx->Tx2Urb)
-	{
+	if (!pWb35Tx->Tx2Urb) {
 		usb_free_urb(pWb35Tx->Tx4Urb);
 		return false;
 	}
-- 
1.7.5.4

