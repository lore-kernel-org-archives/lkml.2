Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0HXEYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:24:49 -0400
Received: from kroah.org ([198.145.64.141]:56445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab0HXEYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:24:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] kobject_uevent: fix typo in comments
Date: Mon, 23 Aug 2010 21:24:39 -0700
Message-Id: <1282623879-17092-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100824040503.GB16749@kroah.com>
References: <20100824040503.GB16749@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <xtfeng@gmail.com>

s/ending/sending, s/kobject_uevent()/kobject_uevent_env() in the comments.

Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.2

