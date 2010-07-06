Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab0GFMaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 08:30:16 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48994 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab0GFMaO (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com:0:0>);
	Tue, 6 Jul 2010 08:30:14 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] cifs: remove an potentially confusing, obsolete comment
Date: Tue,  6 Jul 2010 18:00:10 +0530
Message-Id: <1278419410-8200-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit 6ca9f3bae8b1854794dfa63cdd3b88b7dfe24c13 modified the code so
that filp is full instantiated whenever the file is created and passed back.
The below comment is no longer true, remove it.

Cc: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/dir.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index e7ae78b..a7de5e9 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -130,12 +130,6 @@ cifs_bp_rename_retry:
 	return full_path;
 }
 
-/*
- * When called with struct file pointer set to NULL, there is no way we could
- * update file->private_data, but getting it stuck on openFileList provides a
- * way to access it from cifs_fill_filedata and thereby set file->private_data
- * from cifs_open.
- */
 struct cifsFileInfo *
 cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 		  struct file *file, struct vfsmount *mnt, unsigned int oflags)
