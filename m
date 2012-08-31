Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2HaUCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:02:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64027 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2HaUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:01:05 -0400
From: dongsu.park@profitbricks.com
To: bvanassche@acm.org
Cc: dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, JBottomley@parallels.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>,
        Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: [PATCH 2/5] ib_srp: removed superfluous warning in send timeout case
Date: Fri, 31 Aug 2012 22:00:38 +0200
Message-Id: <1346443241-24844-3-git-send-email-dongsu.park@profitbricks.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsu Park <dongsu.park@profitbricks.com>

Signed-off-By: Sebastian Riemer <sebastian.riemer@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a0d0ca2..1b274484 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -534,7 +534,6 @@ static void srp_wait_last_send_wqe(struct srp_target_port *target)
 		msleep(20);
 	}
 
-	WARN_ON(!target->last_send_wqe);
 }
 
 static void srp_disconnect_target(struct srp_target_port *target)
-- 
1.7.11.1

