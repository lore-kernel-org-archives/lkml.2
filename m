Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1DAE1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:27:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51270 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DAE1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=upan5xjwe8iNtX99w/4aSNEGusStjinawaHKPdWFKkSQy6X6XDjqO61rGcQ28w8JMh
         kpjO86K85tyPYsus6XVOPDxYiKhR0zTa9Gj4kOMomD8SvJcNmt84JwbXrnmWlgAPcR3T
         h6g3hL+VVcjAbfFQZTe4noOUauva+gylJ18i0=
From: namei.unix@gmail.com
To: Alex Elder <aelder@sgi.com>
Cc: Liu Yuan <tailai.ly@taobao.com>,
        xfs-masters@oss.sgi.com (supporter:XFS FILESYSTEM),
        xfs@oss.sgi.com (open list:XFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] =?UTF-8?q?xfs:=20Remove=20unused=20variable=20=E2=80=98bdi=E2=80=99?=
Date: Fri,  1 Apr 2011 12:27:30 +0800
Message-Id: <1301632050-12674-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

When building kernel, I met a warning:
...
fs/xfs/linux-2.6/xfs_buf.c:660: warning: unused variable ‘bdi’
...

So just remove it.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 596bb2c..d917146 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -657,8 +657,6 @@ xfs_buf_readahead(
 	xfs_off_t		ioff,
 	size_t			isize)
 {
-	struct backing_dev_info *bdi;
-
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
-- 
1.7.1

