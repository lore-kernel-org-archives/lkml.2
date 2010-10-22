Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0JVU5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:57:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:36314 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0JVU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:57:06 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 05/11] kdb,ftdump: Remove reference to internal kdb include
Date: Fri, 22 Oct 2010 15:56:25 -0500
Message-Id: <1287780991-7476-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
References: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Oct 2010 20:56:51.0721 (UTC) FILETIME=[A6C3EF90:01CB722B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that include/linux/kdb.h properly exports all the functions
required to dynamically add a kdb shell command, the reference to the
private kdb header can be removed.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/trace/trace_kdb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 7b8ecd7..3c5c5df 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -13,7 +13,6 @@
 #include <linux/kdb.h>
 #include <linux/ftrace.h>
 
-#include "../debug/kdb/kdb_private.h"
 #include "trace.h"
 #include "trace_output.h"
 
-- 
1.6.3.3

