Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2CYX05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:26:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64965 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab2CYX0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:17 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 04/16] dynamic_debug: change ddebug_query core param to dyndbg
Date: Sun, 25 Mar 2012 17:25:42 -0600
Message-Id: <1332717954-5775-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

The "ddebug_query" boot-param allows enabling of pr_debug()s
in built-in modules.  Change it to "dyndbg" to make it
consistent with the $module.dyndbg param added soon.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 563e5fc..1435981 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -623,7 +623,7 @@ static __init int ddebug_setup_query(char *str)
 	return 1;
 }
 
-__setup("ddebug_query=", ddebug_setup_query);
+__setup("dyndbg=", ddebug_setup_query);
 
 /*
  * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
-- 
1.7.7.6

