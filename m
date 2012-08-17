Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2HQFFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:05:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42362 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2HQFFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:05:45 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 3/5] staging/vme: fix checkpatch warning
Date: Fri, 17 Aug 2012 14:05:37 +0900
Message-Id: <1345179937-8339-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
References: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warnings was fixed.

-WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index f12945c..ef4b821 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -601,8 +601,8 @@ static void buf_unalloc(int num)
 {
 	if (image[num].kern_buf) {
 #ifdef VME_DEBUG
-		printk(KERN_DEBUG "UniverseII:Releasing buffer at %p\n",
-			image[num].pci_buf);
+		pr_debug("UniverseII:Releasing buffer at %p\n",
+			 image[num].pci_buf);
 #endif
 
 		vme_free_consistent(image[num].resource, image[num].size_buf,
@@ -614,7 +614,7 @@ static void buf_unalloc(int num)
 
 #ifdef VME_DEBUG
 	} else {
-		printk(KERN_DEBUG "UniverseII: Buffer not allocated\n");
+		pr_debug("UniverseII: Buffer not allocated\n");
 #endif
 	}
 }
-- 
1.7.9.5

