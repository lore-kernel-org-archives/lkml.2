Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1DKCne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 22:43:34 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35830 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1DKCnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 22:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=GPoUjygYtRrlvQiDNEngh/HOysnvtimEsWbpIfimcAok1QLZnsFj4IL5F8DSzEnVfF
         A8BaPG5HI6bm4iFern+f3c03BLQM+AZRDzTON1CimOlFNwHcTZ5Or6lGsRbSAbpdm8z2
         7hbxzpze7IbRuLm9dm0nMMZ9Vix9B8whe8DH4=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
To: aelder@sgi.com, xfs-masters@oss.sgi.com, dchinner@redhat.com, hch@lst.de,
        jaxboe@fusionio.com, tj@kernel.org, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>
Subject: [PATCH 2/2] xfs:remove a warning in xfs_buf_readahead()
Date: Mon, 11 Apr 2011 10:44:53 +0800
Message-Id: <1302489893-31676-1-git-send-email-panweiping3@gmail.com>
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

Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5ea4020..a125b32 100644
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

