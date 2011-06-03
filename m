Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1FCO6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:58:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab1FCO6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:58:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/5] tracing, function, graph: Fixies for field display
Date: Fri,  3 Jun 2011 16:58:46 +0200
Message-Id: <1307113131-10045-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1307111215.3667.53.camel@gandalf.stny.rr.com>
References: <1307111215.3667.53.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

this patchset contains some fixies of trace output for
function and function_graph tracers.

attached patches:
1/5 tracing, function_graph: Remove dependency of abstime and duration fields on latency
2/5 tracing, function_graph: Merge overhead and duration display functions
3/5 tracing, function: Fix trace header to follow context-info option
4/5 tracing, function_graph: Remove lock-depth from latency trace
5/5 tracing, function_graph: Add context-info support for function_graph tracer

v2 changes:
- add description of display changes to patches comments

wbr,
jirka
---
 kernel/trace/trace.c                 |    3 +
 kernel/trace/trace_functions_graph.c |  223 +++++++++++++++++-----------------
 kernel/trace/trace_irqsoff.c         |    4 +-
 kernel/trace/trace_sched_wakeup.c    |    4 +-
 4 files changed, 118 insertions(+), 116 deletions(-)
