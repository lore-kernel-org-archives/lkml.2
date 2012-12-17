Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2LQJiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:38:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53241 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2LQJiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:38:10 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: [PATCH] cifs: Do not enable debugging code by default
Date: Mon, 17 Dec 2012 10:38:05 +0100
Message-Id: <1355737085-6671-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging code is generally disabled in the configurator since it is
only for devs and testers and not for the majority of the installations.

Cc: Joe Perches <joe@perches.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 fs/cifs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 21ff76c22a17..241a0e2853c5 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -124,7 +124,6 @@ config CIFS_ACL
 
 config CIFS_DEBUG
 	bool "Enable CIFS debugging routines"
-	default y
 	depends on CIFS
 	help
 	   Enabling this option adds helpful debugging messages to
-- 
1.8.1.rc2

