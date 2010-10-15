Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0JOQOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:14:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab0JOQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:14:10 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=vJkAFovBFTcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=zgKQy6OAqecPcYlqaekA:9 a=kSDQlXAKWAiAEmYTvw7msbnzhk8A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015161334.766423984@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 12:13:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] ftrace: recordmcount fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/recordmcount tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/recordmcount


Steven Rostedt (2):
      ftrace: Do not process kernel/trace/ftrace.o with C recordmcount program
      ftrace: Use objtree for C version of recordmcount

----
 scripts/Makefile.build |    2 +-
 scripts/recordmcount.c |   22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)
