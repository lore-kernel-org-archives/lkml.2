Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2LTXLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:11:06 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59942 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2LTXKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:10:43 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 4/4] ext4: Fix an incorrect comment about i_mutex
Date: Thu, 20 Dec 2012 15:10:12 -0800
Message-Id: <30dd429015418a31f6412fd1106a2df12d2922dd.1356043686.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <cover.1356043686.git.luto@amacapital.net>
References: <CALCETrUxFHHVPO=EC0jmV9SSKJiOm-mc-xwsd6Ruk3p5nC4fFQ@mail.gmail.com>
 <cover.1356043686.git.luto@amacapital.net>
In-Reply-To: <cover.1356043686.git.luto@amacapital.net>
References: <cover.1356043686.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/ext4/fsync.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index be1d89f..8c15642 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -113,8 +113,6 @@ static int __sync_inode(struct inode *inode, int datasync)
  *
  * What we do is just kick off a commit and wait on it.  This will snapshot the
  * inode to disk.
- *
- * i_mutex lock is held when entering and exiting this function
  */
 
 int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
-- 
1.7.11.7

