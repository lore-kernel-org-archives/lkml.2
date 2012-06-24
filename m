Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2FXOcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 10:32:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2FXOcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 10:32:13 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] vfs, doc: Remove reference to nonexistent FIEMAP_EXTENT_NO_BYPASS
Date: Sun, 24 Jun 2012 07:32:05 -0700
Message-Id: <1340548325-27648-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 24 Jun 2012 07:32:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Presumably this was a flag that was intended to have been created at
some point, but never was.  There are no other references to it
anywhere in the source tree.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/fiemap.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/fiemap.h b/include/linux/fiemap.h
index d830747..645ef70 100644
--- a/include/linux/fiemap.h
+++ b/include/linux/fiemap.h
@@ -49,8 +49,7 @@ struct fiemap {
 						    * Sets EXTENT_UNKNOWN. */
 #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can not be read
 						    * while fs is unmounted */
-#define FIEMAP_EXTENT_DATA_ENCRYPTED	0x00000080 /* Data is encrypted by fs.
-						    * Sets EXTENT_NO_BYPASS. */
+#define FIEMAP_EXTENT_DATA_ENCRYPTED	0x00000080 /* Data is encrypted by fs.*/
 #define FIEMAP_EXTENT_NOT_ALIGNED	0x00000100 /* Extent offsets may not be
 						    * block aligned. */
 #define FIEMAP_EXTENT_DATA_INLINE	0x00000200 /* Data mixed with metadata.
-- 
1.7.10.2

