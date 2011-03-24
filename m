Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab1CXUUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:20:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56204 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934180Ab1CXUTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Rd3MzsCmq0q4Pp4KzaPgqvIFuMvIT+G0kcbLbBDP+vXGNItNGJo/4SrYm/yKp/7wJ9
         KLF4y9Wv4oKqqYT2Djoex870T17fpcri2SMvSU0HTo7fb2A6z+qpOEYdaIPF0t0MFnMz
         EbHAPo1Ngux7NQdJO/cj71YFVvNRDlPQ9eBLA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 17/21]kernel:pm_qos_params.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:36 -0700
Message-Id: <1300997920-31573-17-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
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

