Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0GPQnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:43:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44272 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0GPQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wDgjYK5Nn08HIjindMfxDHqS9MMuVBGNjMJwPNHM0BQYVyIwd+gaQIuEHYWUIER7gB
         TAhxTfvgJgE0mIUog0Ytq14k+VjFcpVd4BY0CXxXpZJ1LLdnoYhI9K/S1jtD+IWE1Fau
         kA0q3CIDWIf/muIzOJLfQnU+hHhKF7axBM0OI=
From: Stephen Boyd <bebarino@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        trivial@kernel.org
Subject: 
Date: Fri, 16 Jul 2010 09:43:05 -0700
Message-Id: <1279298585-4044-1-git-send-email-bebarino@gmail.com>
X-Mailer: git-send-email 1.7.2.rc2.10.g637ab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] fs/Kconfig: Fix typo Userpace -> Userspace

Signed-off-by: Stephen Boyd <bebarino@gmail.com>
---
 fs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 5f85b59..3d18530 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -64,7 +64,7 @@ source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
 
 config CUSE
-	tristate "Character device in Userpace support"
+	tristate "Character device in Userspace support"
 	depends on FUSE_FS
 	help
 	  This FUSE extension allows character devices to be
-- 
1.7.2.rc2.10.g637ab

