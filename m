Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0IEByI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 21:54:08 -0400
Received: from mail.perches.com ([173.55.12.10]:1376 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab0IEBxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 21:53:09 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] kernel/pm_qos_params.c: Remove unnecessary casts of private_data
Date: Sat,  4 Sep 2010 18:52:50 -0700
Message-Id: <abede69b0f7651219da90ecb0e621466c545f15c.1283650107.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <cover.1283650107.git.joe@perches.com>
References: <cover.1283650107.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/pm_qos_params.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index b7e4c36..8414e51 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -396,7 +396,7 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 	} else
 		return -EINVAL;
 
-	pm_qos_req = (struct pm_qos_request_list *)filp->private_data;
+	pm_qos_req = filp->private_data;
 	pm_qos_update_request(pm_qos_req, value);
 
 	return count;
-- 
1.7.2.19.g9a302

