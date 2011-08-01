Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1HAUu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:50:27 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14292 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab1HAUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:50:21 -0400
Date: Mon, 1 Aug 2011 22:50:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Baron <jbaron@redhat.com>, Greg Banks <gnb@melbourne.sgi.com>
Subject: [PATCH][Resend] Remove unneeded version.h include from lib/
Message-ID: <alpine.LNX.2.00.1108012246470.31999@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an unneeded include of linux/version.h from
lib/dynamic_debug.c - identified by 'make versioncheck'.
This is the only file in lib/ with this issue.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 lib/dynamic_debug.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 75ca78f..79fc20b 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kallsyms.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/proc_fs.h>
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

