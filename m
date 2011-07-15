Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801Ab1GODlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 23:41:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35651 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab1GODlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 23:41:03 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=5zp3lynSvqQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=hQYdE7dNJicvm8uStuQA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110715033855.206223173@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jul 2011 23:38:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL][v3.0] ftrace: urgent fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I noticed that tip/perf/urgent wasn't pulled yet. I added it to this
pull request. The first patch is what you reported to me, the second
is a regression that Thomas stumbled upon.

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent-2

Head SHA1: f7bc8b61f65726ff98f52e286b28e294499d7a08


Steven Rostedt (2):
      ftrace: Fix warning when CONFIG_FUNCTION_TRACER is not defined
      ftrace: Fix regression where ftrace breaks when modules are loaded

----
 include/linux/ftrace.h |    4 ++--
 kernel/trace/ftrace.c  |   30 ++++++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)
