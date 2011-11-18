Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1KRFca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:32:30 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52055 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1KRFc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:32:29 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 18/18] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:32:23 -0700
Message-Id: <1321594343-9948-1-git-send-email-zac.3.14159@gmail.com>
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
index d1ffd42..3d56804 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -4176,7 +4176,7 @@ static void mgsl_release_resources(struct mgsl_struct *info)
 		iounmap(info->memory_base);
 		info->memory_base = NULL;
 	}
-	if (info->lcr_base){
+	if (info->lcr_base) {
 		iounmap(info->lcr_base - info->lcr_offset);
 		info->lcr_base = NULL;
 	}
-- 
1.7.7.3

