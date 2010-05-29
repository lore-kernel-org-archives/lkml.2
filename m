Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0E2Sp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 14:45:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52882 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0E2Sp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 14:45:27 -0400
Date: Sat, 29 May 2010 11:45:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] blktrace: fix new kernel-doc warnings
Message-Id: <20100529114507.c466fc1e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C0160BC.0183:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix blktrace.c kernel-doc warnings:
Warning(kernel/trace/blktrace.c:858): No description found for parameter 'ignore'
Warning(kernel/trace/blktrace.c:890): No description found for parameter 'ignore'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Steven Rostedt <rostedt@goodmis.org>
Cc:	Frederic Weisbecker <fweisbec@gmail.com>
Cc:	Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/blktrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.34-git15.orig/kernel/trace/blktrace.c
+++ linux-2.6.34-git15/kernel/trace/blktrace.c
@@ -842,6 +842,7 @@ static void blk_add_trace_split(void *ig
 
 /**
  * blk_add_trace_remap - Add a trace for a remap operation
+ * @ignore:	trace callback data parameter (not used)
  * @q:		queue the io is for
  * @bio:	the source bio
  * @dev:	target device
@@ -873,6 +874,7 @@ static void blk_add_trace_remap(void *ig
 
 /**
  * blk_add_trace_rq_remap - Add a trace for a request-remap operation
+ * @ignore:	trace callback data parameter (not used)
  * @q:		queue the io is for
  * @rq:		the source request
  * @dev:	target device
