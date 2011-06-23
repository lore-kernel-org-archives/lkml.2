Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1FWWFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:05:41 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23794 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1FWWFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:05:40 -0400
Date: Thu, 23 Jun 2011 23:56:46 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Baron <jbaron@redhat.com>, Greg Banks <gnb@melbourne.sgi.com>
Subject: [PATCH 02/37] Remove unneeded version.h include from lib/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106232354470.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
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
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

