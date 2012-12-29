Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2L2WiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 17:38:14 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54159 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab2L2WiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 17:38:12 -0500
From: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Sergei Trofimovich <slyfox@gentoo.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] um: add missing declaration of 'getrlimit()' and friends
Date: Sun, 30 Dec 2012 01:37:30 +0300
Message-Id: <1356820651-8495-1-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.8.0.2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/os-Linux/start_up.c: In function 'check_coredump_limit':
arch/um/os-Linux/start_up.c:338:16: error: storage size of 'lim' isn't known
arch/um/os-Linux/start_up.c:339:2: error: implicit declaration of function 'getrlimit' [-Werror=implicit-function-declaration]

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
CC: Jeff Dike <jdike@addtoit.com>
CC: Richard Weinberger <richard@nod.at>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net
CC: user-mode-linux-user@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
---
 arch/um/os-Linux/start_up.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index da4b9e9..337518c 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -15,6 +15,8 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include <asm/unistd.h>
 #include <init.h>
 #include <os.h>
-- 
1.8.0.2

