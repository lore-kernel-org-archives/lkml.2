Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0INU2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:28:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0INU2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:28:44 -0400
X-Authority-Analysis: v=1.1 cv=0gh5jMB3jHrmQHbUKMg9KP0ZqNkm6dXs7xuA8CfKDuU= c=1 sm=0 a=HxLieBkBJOwA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=2nL_8ljwBqmHtyyzmgAA:9 a=6ghVuhMymD3nkrHZTl4A:7 a=4NjsEzzi-kb-6jw3zv4DeF_yu0UA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100914202714.376849326@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Sep 2010 16:27:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] [GIT PULL] tracing: real fix for set_ftrace_filter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This includes the real fix for the bug that was found for
set_ftrace_filter. Since I noticed that Linus's tree has the
quick fix that Christ Wright and I made, I just based off of
mainline.

-- Steve

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (4):
      tracing: Do not reset *pos in set_ftrace_filter
      tracing: Replace typecasted void pointer in set_ftrace_filter code
      tracing: Keep track of set_ftrace_filter position and allow lseek again
      tracing: Fix reading of set_ftrace_filter across lists

----
 kernel/trace/ftrace.c |  105 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 76 insertions(+), 29 deletions(-)
