Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0KRBej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:34:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39853 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0KRBcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=waOl2nlgdNtkbkht/07t4GFv9M2jwC7Nd930WomKNEnm9iNootAK4KnpDDbxHea1na
         Q0uxYjr2lZ3DOwjWS20jTpd9pd14W68MAMpKK2PaZftwWrkVqlTCANX/u61nql96pf3V
         hj3vEf1K4dO69G7C1yCyAKGEmIBqHId+oyxXE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 0/5] Allow syscalls tracepoints to non privileged users
Date: Thu, 18 Nov 2010 02:32:38 +0100
Message-Id: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Tell me if you're fine with it, and if so I'll push it.

Thanks.

Frederic Weisbecker (5):
  tracing: New flag to allow non privileged users to use a trace event
  tracing: New macro to set up initial event flags value
  tracing: Allow raw syscall trace events for non privileged users
  tracing: Allow syscall trace events for non privileged users
  tracing: Remove useless syscall ftrace_event_call declaration

 include/linux/ftrace_event.h    |   10 ++++++++++
 include/linux/syscalls.h        |   10 ++++------
 include/linux/tracepoint.h      |    4 ++++
 include/trace/events/syscalls.h |    4 ++++
 include/trace/ftrace.h          |    7 +++++++
 kernel/perf_event.c             |    9 ---------
 kernel/trace/trace_event_perf.c |   31 ++++++++++++++++++++++++++++++-
 7 files changed, 59 insertions(+), 16 deletions(-)

