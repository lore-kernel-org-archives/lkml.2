Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1CGIWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:22:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60411 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1CGIVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=BLWRLPIKgHbW0csVaK2O5aK/nwxAWngZcMcHK6d6fSnYf2Z1oEZw4Ad+BwEw+njSPb
         zZKuuT0OBfEwBi6/15t2/pl3FGoDnYIQdLRCl8aPPaOxnU4AIG50Yn0Yuu7tud0a9cc+
         NHORuf9OvdqUsV7uatijrYzYfOEJPpLcl1UB8=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 10/21] staging: ft1000: Fix coding style in ft1000_reset function.
Date: Mon,  7 Mar 2011 09:21:15 +0100
Message-Id: <1299486086-7325-11-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 0b8ff3d..4c5f443 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -882,8 +882,8 @@ int reg_ft1000_netdev(struct ft1000_device *ft1000dev,
 
 static int ft1000_reset(struct net_device *dev)
 {
-    ft1000_reset_card(dev);
-    return 0;
+	ft1000_reset_card(dev);
+	return 0;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

