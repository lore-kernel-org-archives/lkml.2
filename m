Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0CZMc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab0CZMcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:32:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/2] tracing: function graph output for preempt/irqs-off tracers
Date: Fri, 26 Mar 2010 13:32:01 +0100
Message-Id: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I reworked it based on your comments:

- the function_graph tracer should have the same output
  as current version even with events enabled,
  unless I missed something again ;)

- I gave up the idea of function_graph events,
  since it was unsuitable for outputing other
  events as comments "/* */"

- I'm not including the raw function_graph for now


attached patches:
- 1/2 graph output support for irqsoff tracer
- 2/2 graph output support for preemptirqsoff/preemptoff tracers

plz let me know what you think

wbr,
jirka
---
 kernel/trace/trace.c                 |   31 ++++--
 kernel/trace/trace.h                 |   10 ++
 kernel/trace/trace_functions_graph.c |   15 ++-
 kernel/trace/trace_irqsoff.c         |  200 ++++++++++++++++++++++++++++++++-
 4 files changed, 233 insertions(+), 23 deletions(-)
