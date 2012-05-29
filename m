Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2E2HV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:21:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48243 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2E2HV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:21:57 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Parav Pandit <parav.pandit@emulex.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] RDMA/ocrdma: Remove version.h includes
Date: Tue, 29 May 2012 12:51:47 +0530
Message-Id: <1338276107-22169-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when ran with make versioncheck the ocrdma_verbs.h ocrdma_main.c includes
version.h which are not needed.

drivers/infiniband/hw/ocrdma/ocrdma_main.c: 29 linux/version.h not needed.
drivers/infiniband/hw/ocrdma/ocrdma_verbs.h: 31 linux/version.h not needed.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index a20d16e..04fef3d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -26,7 +26,6 @@
  *******************************************************************/
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/idr.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index e648343..633f03d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -28,7 +28,6 @@
 #ifndef __OCRDMA_VERBS_H__
 #define __OCRDMA_VERBS_H__
 
-#include <linux/version.h>
 int ocrdma_post_send(struct ib_qp *, struct ib_send_wr *,
 		     struct ib_send_wr **bad_wr);
 int ocrdma_post_recv(struct ib_qp *, struct ib_recv_wr *,
-- 
1.7.9.5

