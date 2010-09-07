Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab0IGQsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:48:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47445 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996Ab0IGQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=CeUSdm09kDTcVqJkH1/KFfOXU66KWN1mQCp0VssZ3YmrfWiMKN9PrtZZn197k9Dm5h
         N1DKrk1YQDcYTN0IXihHCsexw1/rDJTpzWo7YgYtvEPQF1tTjn9SEkBf6M3v3Fhlv2cX
         8ZAGr5i2PbwddQtv9JlrHqwD1La/7tpdKGBuo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing updates
Date: Tue,  7 Sep 2010 18:48:06 +0200
Message-Id: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
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

Koki Sanagi (3):
      netdev: Add tracepoints to netdev layer
      skb: Add tracepoints to freeing skb
      perf: Add a script to show packets processing

Lai Jiangshan (1):
      irq: Add tracepoint to softirq_raise

Neil Horman (1):
      napi: Convert trace_napi_poll to TRACE_EVENT


 include/linux/interrupt.h                         |    8 +-
 include/trace/events/irq.h                        |   26 +-
 include/trace/events/napi.h                       |   25 +-
 include/trace/events/net.h                        |   82 ++++
 include/trace/events/skb.h                        |   17 +
 net/core/datagram.c                               |    1 +
 net/core/dev.c                                    |    8 +
 net/core/net-traces.c                             |    1 +
 net/core/skbuff.c                                 |    1 +
 tools/perf/scripts/python/bin/netdev-times-record |    8 +
 tools/perf/scripts/python/bin/netdev-times-report |    5 +
 tools/perf/scripts/python/netdev-times.py         |  464 +++++++++++++++++++++
 12 files changed, 641 insertions(+), 5 deletions(-)
