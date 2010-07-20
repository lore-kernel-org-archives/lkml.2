Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab0GTOnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:43:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53978 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761312Ab0GTOmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=C/Sq/E3NUmZ0Yj/4sz8nbel7FuivSIBYC3z5n25LlZKnMCv2gsxlPht3HXIS/AYNih
         adEHVxJhrje47AHH/NCENiKajD1550gOlEK8bXunsNV3xCnuITBNpA7FZop9dH74tv3s
         huyY8L/EjgZeTkJbiG6RoeuSOE0ITl0RJ3qAs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing updates
Date: Tue, 20 Jul 2010 16:42:02 +0200
Message-Id: <1279636925-5919-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      tracing: Remove sysprof ftrace plugin
      tracing: Remove special traces

Arnd Bergmann (1):
      tracing: Use generic_file_llseek for debugfs


 include/linux/kernel.h        |    5 -
 include/linux/sched.h         |   12 --
 kernel/trace/Kconfig          |    9 -
 kernel/trace/Makefile         |    1 -
 kernel/trace/trace.c          |   73 ++-------
 kernel/trace/trace.h          |   10 --
 kernel/trace/trace_entries.h  |   17 --
 kernel/trace/trace_output.c   |   66 --------
 kernel/trace/trace_selftest.c |   33 ----
 kernel/trace/trace_sysprof.c  |  330 -----------------------------------------
 10 files changed, 15 insertions(+), 541 deletions(-)
