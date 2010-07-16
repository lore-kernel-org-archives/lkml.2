Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0GPQrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:47:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55297 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0GPQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Fs18vIZSksbZnHTlwFfXdxin2HjRlNwJQuzFsryP030gqY8QMRBZ5VDP3WEv3bCJo9
         6Y/COgP1K3dxp+8LzNUAOfGduBLFKQLEdhWkCMwocRJin5qeerM1Fw878YAq1G/n8M3g
         2v6J1li2HCJMT0PHohYaFmJOmU8nn5AxKPk4s=
From: Stephen Boyd <bebarino@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        trivial@kernel.org
Subject: [PATCH] fs/Kconfig: Fix typo Userpace -> Userspace
Date: Fri, 16 Jul 2010 09:46:44 -0700
Message-Id: <1279298804-4496-1-git-send-email-bebarino@gmail.com>
X-Mailer: git-send-email 1.7.2.rc2.10.g637ab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Boyd <bebarino@gmail.com>
---

Ah sorrry, missing subject.

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

