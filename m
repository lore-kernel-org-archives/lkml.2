Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935413Ab1JFNiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:38:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34099 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab1JFNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/15] drbd: Removed dead code
Date: Thu,  6 Oct 2011 15:37:46 +0200
Message-Id: <1317908280-28951-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index d596900..13230d9 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2285,7 +2285,6 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 	enum drbd_ret_code retcode;
 	cpumask_var_t new_cpu_mask;
 	struct drbd_tconn *tconn;
-	int *rs_plan_s = NULL;
 	struct res_opts res_opts;
 	int err;
 
@@ -2336,7 +2335,6 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 	}
 
 fail:
-	kfree(rs_plan_s);
 	free_cpumask_var(new_cpu_mask);
 
 	drbd_adm_finish(info, retcode);
-- 
1.7.4.1

