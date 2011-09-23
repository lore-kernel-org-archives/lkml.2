Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1IWWwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:52:04 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:21683 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1IWWwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:52:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1316818309!39661256!14
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gfs2/inode.c: local functions should be static
Date: Fri, 23 Sep 2011 15:51:32 -0700
User-Agent: KMail/1.9.9
CC: <cluster-devel@redhat.com>, <swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231551.32939.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiets the sparse noise:

warning: symbol 'gfs2_initxattrs' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>

---

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5431de9..5f2b157 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -624,7 +624,7 @@ fail:
 	return error;
 }
 
-int gfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+static int gfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		    void *fs_info)
 {
 	const struct xattr *xattr;
