Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab1CXUTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:19:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51040 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934194Ab1CXUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vmlACaGM3/AWOKa3afv4Fy9KWwsMIzvFc/JIVSbA7EsJ92ofGvg8FE0i2crvVm2I8d
         SJFXVsBFcLDeUbcJHyVK9OC9U8ILIpRX9vDc/dE0fVZhkidF2znzSHFk2B+gc+iQ9hp5
         Pcismld82qPvnGiT4nnIhe2wKVw0NgJKxWd/Y=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 20/21]security:selinux:selinuxfs.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:39 -0700
Message-Id: <1300997920-31573-20-git-send-email-justinmattock@gmail.com>
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
 security/selinux/selinuxfs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ea39cb7..47b7d62 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -280,7 +280,7 @@ static ssize_t sel_write_disable(struct file *file, const char __user *buf,
 
 	length = -ENOMEM;
 	if (count >= PAGE_SIZE)
-		goto out;;
+		goto out;
 
 	/* No partial writes. */
 	length = -EINVAL;
@@ -876,12 +876,12 @@ static ssize_t sel_write_user(struct file *file, char *buf, size_t size)
 
 	length = task_has_security(current, SECURITY__COMPUTE_USER);
 	if (length)
-		goto out;;
+		goto out;
 
 	length = -ENOMEM;
 	con = kzalloc(size + 1, GFP_KERNEL);
 	if (!con)
-		goto out;;
+		goto out;
 
 	length = -ENOMEM;
 	user = kzalloc(size + 1, GFP_KERNEL);
@@ -941,7 +941,7 @@ static ssize_t sel_write_member(struct file *file, char *buf, size_t size)
 	length = -ENOMEM;
 	scon = kzalloc(size + 1, GFP_KERNEL);
 	if (!scon)
-		goto out;;
+		goto out;
 
 	length = -ENOMEM;
 	tcon = kzalloc(size + 1, GFP_KERNEL);
-- 
1.7.4.1

