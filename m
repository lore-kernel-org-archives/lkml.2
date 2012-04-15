Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2DOO75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 10:59:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab2DOO74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 10:59:56 -0400
Date: Sun, 15 Apr 2012 17:59:48 +0300
From: Gleb Natapov <gleb@redhat.com>
To: acme@ghostprotocols.net
Cc: a.p.zijlstra@chello.nl, mingo@redhat.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH] perf tools: Add 'G' and 'H' modifiers to event parsing
Message-ID: <20120415145948.GK11918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were dropped during conversion of event parser.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 05d766e..37a3f17 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -54,7 +54,7 @@ num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
-modifier_event	[ukhp]{1,5}
+modifier_event	[ukhpGH]{1,5}
 modifier_bp	[rwx]
 
 %%
--
			Gleb.
