Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1CZQ0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:26:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1CZQ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i4zLKesVtaTFoWsqiWriiVTs4OQbqW3Jw0DS4HjAHJ6QWMRP6xfszyvJFOcfuDUwiV
         47fELNP2oJW3t3FPRSsZExhDOMoGuWtuJDiPj9NZkHItJy8undfS1TA2+hM1bYZDxGje
         wMZdjKTc/oyZkgXvRVYWctb4jQii4ZFBZe0+E=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 1/2] Fixed the format of column longer than 80 .
Date: Sun, 27 Mar 2011 00:25:25 +0800
Message-Id: <1301156726-23610-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/base/memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 drivers/base/memory.c

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
old mode 100644
new mode 100755
index 3da6a43..3e9aa3d
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
1.7.3

