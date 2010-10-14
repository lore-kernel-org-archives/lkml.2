Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0JNTnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:43:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55413 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0JNTnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=hMcSJt6JWZ3MfHCMfKYnWM6v5t1tir9RgVETAXExKfG2mtYRx8aTP+yq+8lO3qUMO0
         fuLpLL6dmERXz8cbUR/kplh0BNoPy0KfAkZ78guHLu0bCYhLhUoy2rWVFFRgYuiAxffj
         fApfYU7Kz0kCtLuFw2eNP+WS6mCOaZPtLdMQI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] small instrumentation updates
Date: Thu, 14 Oct 2010 21:42:49 +0200
Message-Id: <1287085371-29177-1-git-send-regression-fweisbec@gmail.com>
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

Borislav Petkov (1):
      tracing: Fix function-graph build warning on 32-bit

Frederic Weisbecker (1):
      x86: Barf when vmalloc and kmemcheck faults happen in NMI


 arch/x86/mm/fault.c                  |    4 ++++
 arch/x86/mm/kmemcheck/kmemcheck.c    |    2 ++
 kernel/trace/trace_functions_graph.c |    5 +++--
 3 files changed, 9 insertions(+), 2 deletions(-)
