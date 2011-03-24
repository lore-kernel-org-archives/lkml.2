Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab1CXT2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:28:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53790 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934028Ab1CXT2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N0Xvlr+m6/cZk1iG/ETpUTkjp098jtJPOYCs+diObEgllGIyFS4ElFwyJNDzoiPc82
         R9Mif27oXYcGmz2LQMoPC2UAQsEXQqTxfGQ1axzh/6X4rOkRHMW9b6knRUWJWHU7kOM/
         F/ZIx5KbUWZ5+yBy5U+7PAwlOd4syn2LsrfXM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 17/21]kernel:pm_qos_params.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:55 -0700
Message-Id: <1300994819-30930-17-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 kernel/pm_qos_params.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 0da058b..beb1846 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -385,7 +385,7 @@ static ssize_t pm_qos_power_read(struct file *filp, char __user *buf,
 	s32 value;
 	unsigned long flags;
 	struct pm_qos_object *o;
-	struct pm_qos_request_list *pm_qos_req = filp->private_data;;
+	struct pm_qos_request_list *pm_qos_req = filp->private_data;
 
 	if (!pm_qos_req)
 		return -EINVAL;
-- 
1.7.4.1

