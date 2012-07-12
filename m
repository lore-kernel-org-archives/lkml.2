Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161602Ab2GLVwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:52:18 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:65153 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2GLVvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:51:06 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 4/8] staging: ft1000-usb: Remove spaces from struct dpram_blk.
Date: Thu, 12 Jul 2012 23:50:46 +0200
Message-Id: <1342129850-32209-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
References: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 3f22df9..06bce31 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -142,8 +142,8 @@ struct ft1000_info {
 
 
 struct dpram_blk {
-    struct list_head list;
-    u16 *pbuffer;
+	struct list_head list;
+	u16 *pbuffer;
 } __attribute__ ((packed));
 
 int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx);
-- 
1.7.9.5

