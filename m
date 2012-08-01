Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2HAWY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 18:24:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65525 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2HAWYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 18:24:25 -0400
From: Meredydd Luff <meredydd@senatehouse.org>
To: linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>,
        Meredydd Luff <meredydd@senatehouse.org>
Subject: [PATCH] um: Coding style fix in sys_execve()
Date: Wed,  1 Aug 2012 23:23:54 +0100
Message-Id: <1343859834-4168-1-git-send-email-meredydd@senatehouse.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Submitting this as a separate patch per richard@nod.at's suggestion.

Signed-off-by: Meredydd Luff <meredydd@senatehouse.org>
---
 arch/um/kernel/exec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index 6cade93..e74ec80 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -80,7 +80,8 @@ long sys_execve(const char __user *file, const char __user *const __user *argv,
 
 	filename = getname(file);
 	error = PTR_ERR(filename);
-	if (IS_ERR(filename)) goto out;
+	if (IS_ERR(filename))
+		goto out;
 	error = execve1(filename, argv, env);
 	putname(filename);
  out:
-- 
1.7.4.1

