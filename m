Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1GLJ1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:27:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45977 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1GLJ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:27:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 12 Jul 2011 11:27:20 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH] anonfd: fix missing declaration
To: linux-kernel@vger.kernel.org
Cc: t.stanislaws@samsung.com, davidel@xmailserver.org
Message-id: <1310462840-20462-1-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The forward declaration of struct file_operations is
added to avoid compilation warnings.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 include/linux/anon_inodes.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
index 69a21e0..8013a45 100644
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -8,6 +8,8 @@
 #ifndef _LINUX_ANON_INODES_H
 #define _LINUX_ANON_INODES_H
 
+struct file_operations;
+
 struct file *anon_inode_getfile(const char *name,
 				const struct file_operations *fops,
 				void *priv, int flags);
-- 
1.7.6

