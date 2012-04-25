Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2DYIXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:23:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab2DYIXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:23:45 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] tracing: Various cleanups
Date: Wed, 25 Apr 2012 10:23:35 +0200
Message-Id: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending some small cleanups I gathered along the way ;)

attached patches:
  1/4 ftrace: Remove unused code ftrace related code
  2/4 ftrace: Remove unused ftrace_update_time variable/code
  3/4 ftrace: No return value for ftrace_process_locs
  4/4 tracing: Use seq_*_private interface for some seq files

wbr,
jirka
---
 include/linux/ftrace.h |    7 --
 kernel/trace/ftrace.c  |  199 ++++++++----------------------------------------
 kernel/trace/trace.c   |   27 +------
 3 files changed, 35 insertions(+), 198 deletions(-)
