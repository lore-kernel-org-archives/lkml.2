Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab0KODPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:15:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1125 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab0KODF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:29 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/44] arch/um: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:22 -0800
Message-Id: <9ab60a1761dde357ebc028c525dae7572e072588.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/um/drivers/mmapper_kern.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index 8501e7d..6256fa9 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -122,7 +122,7 @@ static int __init mmapper_init(void)
 	if (err) {
 		printk(KERN_ERR "mmapper - misc_register failed, err = %d\n",
 		       err);
-		return err;;
+		return err;
 	}
 	return 0;
 }
-- 
1.7.3.1.g432b3.dirty

