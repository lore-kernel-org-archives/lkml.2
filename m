Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2EJDJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:09:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38393 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2EJDJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:09:29 -0400
Date: Wed, 9 May 2012 23:09:24 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
Subject: [Bcache v13 06/16] Export blk_fill_rwbs()
Message-ID: <1fd721ea1e5eace41109b6aaa20f57959c341e85.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used by bcache's tracepoints.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 kernel/trace/blktrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index cdea7b5..e26a350 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1820,6 +1820,7 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 
 	rwbs[i] = '\0';
 }
+EXPORT_SYMBOL_GPL(blk_fill_rwbs);
 
 #endif /* CONFIG_EVENT_TRACING */
 
-- 
1.7.9.rc2

