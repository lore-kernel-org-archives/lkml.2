Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2JQC40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:56:26 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33012 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2JQC4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:56:25 -0400
X-AuditID: b753bd60-96850ba000002f78-ca-507e1e56d5cc
X-AuditID: b753bd60-96850ba000002f78-ca-507e1e56d5cc
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH v2 -tip 0/4] tracing: make a snapshot feature available from
 userspace
To: rostedt@goodmis.org
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Oct 2012 11:56:08 +0900
Message-ID: <20121017025608.2627.87497.stgit@falsita>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven,

Thank you for your review.
I changed the function name "resize_buffer_even" to 
"resize_buffer_duplicate_size".

(v1: https://lkml.org/lkml/2012/10/2/67)

---

Hiraku Toyooka (4):
      tracing: add description of snapshot to Documentation/trace/ftrace.txt
      tracing: make a snapshot feature available from userspace
      tracing: add a resize function for making one buffer equivalent to the other buffer
      tracing: change tracer's integer flags to bool


 Documentation/trace/ftrace.txt    |   97 ++++++++++++++
 include/linux/ftrace_event.h      |    3 
 kernel/trace/Kconfig              |   11 ++
 kernel/trace/trace.c              |  248 +++++++++++++++++++++++++++++++------
 kernel/trace/trace.h              |    5 -
 kernel/trace/trace_irqsoff.c      |   12 +-
 kernel/trace/trace_sched_wakeup.c |    8 +
 7 files changed, 333 insertions(+), 51 deletions(-)

-- 
Hiraku TOYOOKA
Linux Technology Center
Yokohama Research Laboratory
Hitachi Ltd.
