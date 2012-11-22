Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab2KVVWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:22:48 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40073 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732Ab2KVVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:22:40 -0500
Message-Id: <20121122212235.448621579@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Nov 2012 01:15:23 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch -mm 1/4] fs, notify: Add missing space after prefix
References: <20121122211522.075455799@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-fsnotify-11-update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While being prepared the first series I occasionally
left "inotify-wd" token not updated. This patch fixes
it and bring space between prefix and the rest of line
back.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
---
 fs/notify/fdinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/fs/notify/fdinfo.c
===================================================================
--- linux-2.6.git.orig/fs/notify/fdinfo.c
+++ linux-2.6.git/fs/notify/fdinfo.c
@@ -86,7 +86,7 @@ static int inotify_fdinfo(struct seq_fil
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(mark->i.inode);
 	if (inode) {
-		ret = seq_printf(m, "inotify-wd:%x ino:%lx sdev:%x "
+		ret = seq_printf(m, "inotify wd:%x ino:%lx sdev:%x "
 				 "mask:%x ignored_mask:%x ",
 				 inode_mark->wd, inode->i_ino,
 				 inode->i_sb->s_dev,

