Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965958Ab0GPQMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:12:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42217 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965891Ab0GPQMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KcEaPtchfXPsnt40Qi4ftthlMNflzts6knrDa3qDxgOk9lS96HgfpoqBwUsXo5GqFi
         tfX+WOq7VkQUIrtsGqzOutIJb4m78+CNZ+UfaPTRHeNx+pI8gJR5NzgWVpH6k3KzH0U1
         /dn0oTsSsROjqsJUKAqkg6BJrZQLIb92bI81Q=
From: Chihau Chau <chihau@gmail.com>
To: jmorris@namei.org
Cc: eparis@redhat.com, serue@us.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Security: capability: code style issue
Date: Fri, 16 Jul 2010 12:11:54 -0400
Message-Id: <1279296714-11916-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fix a little code style issue deleting a space between a function
name and a open parenthesis.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 security/capability.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/capability.c b/security/capability.c
index 8168e3e..1383ad2 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -27,7 +27,7 @@ static int cap_quota_on(struct dentry *dentry)
 	return 0;
 }
 
-static int cap_bprm_check_security (struct linux_binprm *bprm)
+static int cap_bprm_check_security(struct linux_binprm *bprm)
 {
 	return 0;
 }
-- 
1.5.6.3

