Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab2AEMRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:17:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152Ab2AEMQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:37 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/16] GFS2: local functions should be static
Date: Thu,  5 Jan 2012 11:52:02 +0000
Message-Id: <1325764322-10807-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>

Quiets the sparse noise:

warning: symbol 'gfs2_initxattrs' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e0ada04..cb81898 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -621,7 +621,7 @@ fail:
 	return error;
 }
 
-int gfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+static int gfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		    void *fs_info)
 {
 	const struct xattr *xattr;
-- 
1.7.4

