Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0JTWHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:07:17 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39127 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab0JTWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:07:16 -0400
X-Greylist: delayed 6057 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2010 18:07:16 EDT
Date: Wed, 20 Oct 2010 16:26:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: trivial@kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Correct comment for ext[23] filesystem "ctime" field
Message-ID: <alpine.DEB.2.00.1010201624150.3247@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  last i looked, ctime still wasn't the creation time.

diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 2dfa707..e084c99 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -244,7 +244,7 @@ struct ext2_inode {
 	__le16	i_uid;		/* Low 16 bits of Owner Uid */
 	__le32	i_size;		/* Size in bytes */
 	__le32	i_atime;	/* Access time */
-	__le32	i_ctime;	/* Creation time */
+	__le32	i_ctime;	/* Status change time */
 	__le32	i_mtime;	/* Modification time */
 	__le32	i_dtime;	/* Deletion Time */
 	__le16	i_gid;		/* Low 16 bits of Group Id */
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 6ce1bca..30438c0 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -282,7 +282,7 @@ struct ext3_inode {
 	__le16	i_uid;		/* Low 16 bits of Owner Uid */
 	__le32	i_size;		/* Size in bytes */
 	__le32	i_atime;	/* Access time */
-	__le32	i_ctime;	/* Creation time */
+	__le32	i_ctime;	/* Status change time */
 	__le32	i_mtime;	/* Modification time */
 	__le32	i_dtime;	/* Deletion Time */
 	__le16	i_gid;		/* Low 16 bits of Group Id */
-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
