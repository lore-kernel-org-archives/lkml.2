Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1G0EF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:05:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35559 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab1G0EFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:05:53 -0400
X-Sasl-enc: nIvx1SR7IHD5RU+Dq95UMs42t45H8t/n16nF6ZW1gYSX 1311739552
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/11] debugfs: add documentation for debugfs_create_x64
Date: Tue, 26 Jul 2011 21:05:20 -0700
Message-Id: <1311739521-11014-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311739521-11014-1-git-send-email-gregkh@suse.de>
References: <20110726045707.GA2321@kroah.com>
 <1311739521-11014-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

debugfs_create_x64() exists.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/debugfs.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/debugfs.txt b/Documentation/filesystems/debugfs.txt
index ed52af6..742cc06 100644
--- a/Documentation/filesystems/debugfs.txt
+++ b/Documentation/filesystems/debugfs.txt
@@ -73,8 +73,8 @@ the following functions can be used instead:
 				      struct dentry *parent, u16 *value);
     struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 				      struct dentry *parent, u32 *value);
-
-Note that there is no debugfs_create_x64().
+    struct dentry *debugfs_create_x64(const char *name, mode_t mode,
+				      struct dentry *parent, u64 *value);
 
 These functions are useful as long as the developer knows the size of the
 value to be exported.  Some types can have different widths on different
-- 
1.7.6

