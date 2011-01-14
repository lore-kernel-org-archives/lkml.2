Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1ANDwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:52:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51164 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1ANDwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=t2AIt2uv0Fhocu6+E0b0inJM5KodNPBUMCvYvvEfMZI/m9X87bvhjdvMn1+vEsSJ5e
         cXbtRD3H32M0hM60PnwsyRV7+1N9fTYgPADsppaFEVS7PmBHrpPO5KaiuMP74WVyG11H
         T+i9DW4R8+7LPD7OzbKXoY8AYM9Xq6mqyAzMA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/4] perf callchain updates
Date: Fri, 14 Jan 2011 04:51:57 +0100
Message-Id: <1294977121-5700-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Here are some updates for callchains. No fixes though.
Cleanups, naming sanitizing, performance improvement, ...

Thanks.

Frederic Weisbecker (4):
  perf: Feed callchains into a cursor
  perf: Rename cumul_hits into callchain_cumul_hits
  perf: Rename register_callchain_param into callchain_register_param
  perf: Don't give arbitrary gender to callchain tree nodes

 tools/perf/builtin-report.c         |   29 ++---
 tools/perf/util/callchain.c         |  224 +++++++++++++++++------------------
 tools/perf/util/callchain.h         |   74 +++++++++++-
 tools/perf/util/hist.c              |   15 ++-
 tools/perf/util/hist.h              |    2 +
 tools/perf/util/session.c           |   22 ++--
 tools/perf/util/session.h           |   11 +-
 tools/perf/util/ui/browsers/hists.c |    2 +-
 8 files changed, 222 insertions(+), 157 deletions(-)

-- 
1.7.3.2

