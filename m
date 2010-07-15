Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934896Ab0GOWIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:08:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45084 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528Ab0GOWGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=FXg4BodOjt+kllhRWVGL+FpwGQPqD4k9cdtdpUzP1rvP+OeygewcnMAYCg/NkAv2bs
         r++fDMenNSZJWOgyiBK8mzWS+fqEMCdz3hxaJmIl9hytcGu/l/S39LFM41NOaDLbNwJR
         EZiK/gml83IL9WIinh5Zhwe+wPIOPaOaUqSvg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing cleanups
Date: Fri, 16 Jul 2010 00:06:40 +0200
Message-Id: <1279231603-30624-1-git-send-regression-fweisbec@gmail.com>
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

Frederic Weisbecker (3):
      tracing: Update tracing branch url
      tracing: Remove ksym tracer
      tracing: Remove letfover markers section


 MAINTAINERS                       |    2 +-
 include/asm-generic/vmlinux.lds.h |    4 -
 kernel/trace/Kconfig              |   22 --
 kernel/trace/Makefile             |    1 -
 kernel/trace/trace.h              |    6 -
 kernel/trace/trace_entries.h      |   15 -
 kernel/trace/trace_ksym.c         |  508 -------------------------------------
 kernel/trace/trace_selftest.c     |   54 ----
 8 files changed, 1 insertions(+), 611 deletions(-)
