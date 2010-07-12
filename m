Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0GLUwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:52:41 -0400
Received: from mail.perches.com ([173.55.12.10]:1783 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab0GLUvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:51:04 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/36] kernel: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:22 -0700
Message-Id: <86107d95521339af79a2256c9e52b42526834d60.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/pm_qos_params.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 14b757f..c8aa61c 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -394,7 +394,7 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 	} else
 		return -EINVAL;
 
-	pm_qos_req = (struct pm_qos_request_list *)filp->private_data;
+	pm_qos_req = filp->private_data;
 	pm_qos_update_request(pm_qos_req, value);
 
 	return count;
-- 
1.7.1.337.g6068.dirty

