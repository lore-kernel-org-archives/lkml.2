Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1KRFaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:30:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41426 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1KRFaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:30:10 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 17/17] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:30:06 -0700
Message-Id: <1321594206-9841-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/synclink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index d24f216..d1ffd42 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -4172,7 +4172,7 @@ static void mgsl_release_resources(struct mgsl_struct *info)
 		release_mem_region(info->phys_lcr_base + info->lcr_offset,128);
 		info->lcr_mem_requested = false;
 	}
-	if (info->memory_base){
+	if (info->memory_base) {
 		iounmap(info->memory_base);
 		info->memory_base = NULL;
 	}
-- 
1.7.7.3

