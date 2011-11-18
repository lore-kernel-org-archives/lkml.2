Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1KRFwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:52:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60328 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab1KRFwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:52:08 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 25/25] Drivers: tty: synclinkmp: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:52:03 -0700
Message-Id: <1321595523-10634-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/synclinkmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index f4a2d60..61f0137 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -3671,7 +3671,7 @@ static void release_resources(SLMP_INFO *info)
 		info->sca_statctrl_requested = false;
 	}
 
-	if (info->memory_base){
+	if (info->memory_base) {
 		iounmap(info->memory_base);
 		info->memory_base = NULL;
 	}
-- 
1.7.7.3

