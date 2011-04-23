Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1DWOTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 10:19:41 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:60760 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab1DWOTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 10:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UejvZMtbyZZRUEAALECY863otcIs/SLh84vP8fffD2nfxfHzuAWjyzl2ffjJG/LopL
         xqJZ5H4n/N39mzAC4AkTd+wwksCmjKzrJyRfJJzdAS4L0c4ffSkqdU2DABluB2o44RkV
         Ed6fYofAwWTebhfDvzDLycVXVz2OSb7htp3n0=
From: wanlong.gao@gmail.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [resend PATCH] drivers:base:fix the coding format of memory.c
Date: Sat, 23 Apr 2011 22:18:26 +0800
Message-Id: <1303568306-20775-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Fix the line longer than 80 of memory_uevent function .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
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
1.7.3

