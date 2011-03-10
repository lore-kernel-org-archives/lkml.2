Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1CJKwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:52:04 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49636 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1CJKwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cuTldcPIITDyyTY1+quTAgnFfHpA41v1hLUmONgLnc22MHdLQ61dAPUWQu5nEt9Zj9
         XMVhlG+Ip0wgiX3d/BgJ54xl0jD+itOKSKQ23bcCrDMkzwIrA+ty1HyRBpl+yGmW9L7W
         bpVvoDOBJb/zjOhPSZuYiboyxFcH+4qvgWSIE=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 10/21] staging: ft1000: Fix coding style in ft1000_reset function.
Date: Thu, 10 Mar 2011 11:51:24 +0100
Message-Id: <1299754295-8493-11-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
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

