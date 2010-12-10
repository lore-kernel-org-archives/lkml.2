Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0LJDMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:12:21 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:40097 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0LJDMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ss8A6fJmHTZJbTE6ydsdAMcpQP50aNT85lf8EHyEry8dvPyP0ma0DlKwV2mEIXxBrg
         zqkn5TShJRNiX158HznaOZhlPZ67dsryU6bO5FX9qr7AvCoF7ikrEn0AWODGNh7wsb2l
         zgcZYfaKZkkOt8Aur6iNJLUNZrY5iBgXJM24k=
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] anon_inodes: fix a typo in comment
Date: Fri, 10 Dec 2010 12:11:50 +0900
Message-Id: <1291950710-5331-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/anon_inodes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 57ce55b2564c..73097336ea2a 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -64,9 +64,9 @@ static const struct address_space_operations anon_aops = {
 };
 
 /**
- * anon_inode_getfd - creates a new file instance by hooking it up to an
- *                    anonymous inode, and a dentry that describe the "class"
- *                    of the file
+ * anon_inode_getfile - creates a new file instance by hooking it up to an
+ *                      anonymous inode, and a dentry that describe the "class"
+ *                      of the file
  *
  * @name:    [in]    name of the "class" of the new file
  * @fops:    [in]    file operations for the new file
-- 
1.7.3.3.400.g93cef

