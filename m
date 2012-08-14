Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab2HNVTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:19:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54694 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab2HNVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:19:40 -0400
From: Valerio Baudo = <vb.xyvab@gmail.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Valerio Baudo <vb.xyvab@gmail.com>
Subject: [PATCH] Init: main: fixed a brace coding style issue
Date: Tue, 14 Aug 2012 12:24:33 +0200
Message-Id: <1344939873-21215-1-git-send-email-vb.xyvab@gmail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerio Baudo <vb.xyvab@gmail.com>

Fixed a coding style issue.

Signed-off-by: Valerio Baudo <vb.xyvab@gmail.com>
---
 init/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index e60679d..3951ab4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -342,8 +342,8 @@ static void __init setup_command_line(char *command_line)
 {
 	saved_command_line = alloc_bootmem(strlen (boot_command_line)+1);
 	static_command_line = alloc_bootmem(strlen (command_line)+1);
-	strcpy (saved_command_line, boot_command_line);
-	strcpy (static_command_line, command_line);
+	strcpy(saved_command_line, boot_command_line);
+	strcpy(static_command_line, command_line);
 }
 
 /*
-- 
1.7.11.2

