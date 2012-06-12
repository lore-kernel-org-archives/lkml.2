Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2FLPn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:43:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59313 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab2FLPjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:39:49 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: [Bcache v14 05/16] Export blk_fill_rwbs()
Date: Tue, 12 Jun 2012 08:39:11 -0700
Message-Id: <1339515562-14638-6-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1339515562-14638-1-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used by bcache's tracepoints.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 kernel/trace/blktrace.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..dbe1667 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1806,6 +1806,7 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 
 	rwbs[i] = '\0';
 }
+EXPORT_SYMBOL_GPL(blk_fill_rwbs);
 
 #endif /* CONFIG_EVENT_TRACING */
 
-- 
1.7.9.3.327.g2980b

