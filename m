Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2F0IjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:39:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50669 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2F0IjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:39:20 -0400
MIME-Version: 1.0
Date: Wed, 27 Jun 2012 16:39:19 +0800
Message-ID: <CACV3sbKFcHgai6AzKGrf=LEb67VjZXjMUqMQuXAOUmby7CeiJg@mail.gmail.com>
Subject: [PATCH] perf: fix wrong hw_breakpoint documentation
From: Jovi Zhang <bookjovi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, mingo@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: jovi zhang <bookjovi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f5f9c3a064482cf3d0fb7ed788c66630bddbfc79 Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Wed, 27 Jun 2012 16:09:21 +0800
Subject: [PATCH] perf: fix wrong hw_breakpoint documentation

read-write access hw_breakpoint event is passed as 'mem:addr',
'mem:0x1000:rw' is parsed as invalid argument currently.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 tools/perf/Documentation/perf-record.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-record.txt
b/tools/perf/Documentation/perf-record.txt
index b38a1f9..f9321b3 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -38,7 +38,7 @@ OPTIONS
           Access is the memory access type (read, write, execute) it can
           be passed as follows: '\mem:addr[:[r][w][x]]'.
           If you want to profile read-write accesses in 0x1000, just set
-          'mem:0x1000:rw'.
+          'mem:0x1000'.

 --filter=<filter>::
         Event filter.
--
1.7.9.7
