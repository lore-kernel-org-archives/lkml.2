Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965784Ab2EOCqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:46:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:49712 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965006Ab2EOCR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 110/179] NFSv4.1: update nfs4_fattr_bitmap_maxsz
Date: Mon, 14 May 2012 22:13:26 -0400
Message-ID: <1337048075-6132-111-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Adamson <andros@netapp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e5012d1f3861d18c7f3814e757c1c3ab3741dbcd upstream.

Attribute IDs assigned in RFC 5661 now require three bitmaps.
Fixes hitting a BUG_ON in xdr_shrink_bufhead when getting ACLs.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 63ec2b7..c1a2f66 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -89,7 +89,7 @@ static int nfs4_stat_to_errno(int);
 #define encode_getfh_maxsz      (op_encode_hdr_maxsz)
 #define decode_getfh_maxsz      (op_decode_hdr_maxsz + 1 + \
 				((3+NFS4_FHSIZE) >> 2))
-#define nfs4_fattr_bitmap_maxsz 3
+#define nfs4_fattr_bitmap_maxsz 4
 #define encode_getattr_maxsz    (op_encode_hdr_maxsz + nfs4_fattr_bitmap_maxsz)
 #define nfs4_name_maxsz		(1 + ((3 + NFS4_MAXNAMLEN) >> 2))
 #define nfs4_path_maxsz		(1 + ((3 + NFS4_MAXPATHLEN) >> 2))
-- 
1.7.9.6

