Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944Ab1ETAQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:16:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51109 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934733Ab1ETALp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:45 -0400
X-Sasl-enc: DdyIAkGxE1RvXb7GmNG2Q01/uDZDYY2nCbS1aVeKYd8o 1305850304
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <wanlong.gao@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/44] drivers:base:fix the coding format of memory.c
Date: Thu, 19 May 2011 17:10:41 -0700
Message-Id: <1305850262-9575-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Fix the line longer than 80 of memory_uevent function .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 3da6a43..3e9aa3d 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -48,7 +48,8 @@ static const char *memory_uevent_name(struct kset *kset, struct kobject *kobj)
 	return MEMORY_CLASS_NAME;
 }
 
-static int memory_uevent(struct kset *kset, struct kobject *obj, struct kobj_uevent_env *env)
+static int memory_uevent(struct kset *kset, struct kobject *obj,
+			struct kobj_uevent_env *env)
 {
 	int retval = 0;
 
-- 
1.7.4.2

