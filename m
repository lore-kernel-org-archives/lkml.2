Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218Ab0HMK6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934171Ab0HMK6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:58:34 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: gregkh@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <xtfeng@gmail.com>
Subject: [PATCH] kobject_uevent: fix typo in comments
Date: Fri, 13 Aug 2010 18:58:10 +0800
Message-Id: <1281697090-6694-1-git-send-email-xtfeng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/ending/sending, s/kobject_uevent()/kobject_uevent_env() in the comments.

Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
---
 lib/kobject_uevent.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index b935795..70af0a7 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -123,7 +123,7 @@ static int kobj_usermode_filter(struct kobject *kobj)
  * @kobj: struct kobject that the action is happening to
  * @envp_ext: pointer to environmental data
  *
- * Returns 0 if kobject_uevent() is completed with success or the
+ * Returns 0 if kobject_uevent_env() is completed with success or the
  * corresponding error when it fails.
  */
 int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
@@ -317,7 +317,7 @@ exit:
 EXPORT_SYMBOL_GPL(kobject_uevent_env);
 
 /**
- * kobject_uevent - notify userspace by ending an uevent
+ * kobject_uevent - notify userspace by sending an uevent
  *
  * @action: action that is happening
  * @kobj: struct kobject that the action is happening to
-- 
1.7.2.1

