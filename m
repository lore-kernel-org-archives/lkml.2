Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1GYVnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59434 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1GYVnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:17 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 01/25] dynamic_debug: add pending flag 'a' to make pending queries explicit
Date: Mon, 25 Jul 2011 15:42:26 -0600
Message-Id: <1311630170-26057-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this just adds flag to header, so it can be rebased to the front of
the patchset, so that rebuilds within the set are faster.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index bc75472..8f46a5d 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -26,6 +26,7 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_INCL_FUNCNAME	(1<<2)
 #define _DPRINTK_FLAGS_INCL_LINENO	(1<<3)
 #define _DPRINTK_FLAGS_INCL_TID		(1<<4)
+#define _DPRINTK_FLAGS_APPEND   (1<<5)  /* add query to pending list */
 #define _DPRINTK_FLAGS_DEFAULT 0
 	unsigned int flags:8;
 	char enabled;
-- 
1.7.4.1

