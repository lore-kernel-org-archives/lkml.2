Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0GLU5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:57:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1727 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab0GLUuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:39 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 09/36] drivers/infiniband: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:01 -0700
Message-Id: <0074ff36bc27b141d3639e2d516cc6cd48364df6.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 9c5c66d..65eb892 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -2055,7 +2055,7 @@ static int ipath_close(struct inode *in, struct file *fp)
 
 	mutex_lock(&ipath_mutex);
 
-	fd = (struct ipath_filedata *) fp->private_data;
+	fd = fp->private_data;
 	fp->private_data = NULL;
 	pd = fd->pd;
 	if (!pd) {
-- 
1.7.1.337.g6068.dirty

