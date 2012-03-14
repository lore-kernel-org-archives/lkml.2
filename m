Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031208Ab2CNXFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:05:07 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62306 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2CNXCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:02:31 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 02/11] dynamic_debug: fix leading spaces
Date: Wed, 14 Mar 2012 17:01:57 -0600
Message-Id: <1331766126-11674-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

clean up some space-before-tabs problems.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 7e3c53a..bf1b0fc 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -17,8 +17,8 @@ struct _ddebug {
 	const char *format;
 	unsigned int lineno:18;
 	/*
- 	 * The flags field controls the behaviour at the callsite.
- 	 * The bits here are changed dynamically when the user
+	 * The flags field controls the behaviour at the callsite.
+	 * The bits here are changed dynamically when the user
 	 * writes commands to <debugfs>/dynamic_debug/control
 	 */
 #define _DPRINTK_FLAGS_NONE	0
-- 
1.7.7.6

