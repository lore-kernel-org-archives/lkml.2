Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1BEUjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:39:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:34536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab1BEUjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:39:47 -0500
Date: Sat, 5 Feb 2011 20:39:38 +0000
From: Denis Kirjanov <dkirjanov@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, acme@ghostprotocols.net
Subject: [PATCH] perftools: builtin-top: Use pid_t for target_{pid|tid}
Message-ID: <20110205203938.GA15328@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 05 Feb 2011 20:39:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pid_t data type for target_{pid|tid} vars.

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
 tools/perf/builtin-top.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b6998e0..e4ea084 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -67,8 +67,8 @@ static int			default_interval		=      0;
 static int			count_filter			=      5;
 static int			print_entries;
 
-static int			target_pid			=     -1;
-static int			target_tid			=     -1;
+static pid_t			target_pid			=     -1;
+static pid_t			target_tid			=     -1;
 static struct thread_map	*threads;
 static bool			inherit				=  false;
 static struct cpu_map		*cpus;
-- 
1.7.3.4

