Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1FNIgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:36:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35542 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab1FNIf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:35:57 -0400
X-AuditID: b753bd60-a0aaaba0000019f4-13-4df71d6bd09e
X-AuditID: b753bd60-a0aaaba0000019f4-13-4df71d6bd09e
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v3 0/3] Support stacktrace with dynamic event
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org
Date: Tue, 14 Jun 2011 16:02:50 +0900
Message-ID: <20110614070250.3628.94917.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the 3rd version of stacktrace support with
dynamic event tracer.

I've just fix patch styles according to Ingo's
comments.

Thank you,

---

Masami Hiramatsu (3):
      [BUGFIX]tracing/kprobes: Fix kprobe-tracer to support stack trace
      Add weak save_stack_trace_regs()
      [CLEANUP]x86: Swap save_stack_trace_regs parameters


 arch/x86/kernel/stacktrace.c  |    2 +-
 arch/x86/mm/kmemcheck/error.c |    2 +-
 include/linux/ftrace_event.h  |    4 ++++
 include/linux/stacktrace.h    |    4 ++--
 kernel/stacktrace.c           |   14 ++++++++++----
 kernel/trace/trace.c          |   34 +++++++++++++++++++++++++++++-----
 kernel/trace/trace.h          |    9 +++++++++
 kernel/trace/trace_kprobe.c   |    6 ++++--
 8 files changed, 60 insertions(+), 15 deletions(-)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

