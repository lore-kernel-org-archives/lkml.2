Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1C3D1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 23:27:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61815 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab1C3D1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 23:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=sMXx3CbH4wTaPza/SOcZwLHp482hBjd2Oq9Q5UXr8sHK1bQPSVMWlzTrnCr02ETTar
         tEgT/R7qeveICp+RibL6dG45MgRqR22SgDdgEYdCLh3UaxzBWPaWzJQlPnanisxkfe5m
         +Wdqcoe2ZtCYxhKqJSdnUItjdpqPJlXgOVmec=
From: Pan Weiping <panweiping3@gmail.com>
To: aelder@sgi.com, xfs-masters@oss.sgi.com, dchinner@redhat.com, hch@lst.de,
        tj@kernel.org, jaxboe@fusionio.com
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Pan Weiping <panweiping3@gmail.com>
Subject: [PATCH] delete a warning in function xfs_buf_readahead
Date: Wed, 30 Mar 2011 11:28:06 +0800
Message-Id: <1301455686-21517-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/home/pwp/mysvn/linux/linux-2.6/fs/xfs/linux-2.6/xfs_buf.c: In function
‘xfs_buf_readahead’:
/home/pwp/mysvn/linux/linux-2.6/fs/xfs/linux-2.6/xfs_buf.c:660:27: warning:
unused variable ‘bdi’
Signed-off-by: Pan Weiping <panweiping3@gmail.com>
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
1.7.4

