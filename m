Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1GFVUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:20:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41984 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab1GFVUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:20:17 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=kZnf3UDK9bUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=xD3b4sr2fvHOm6Ufq0AA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110706211931.764277374@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 17:19:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL][v3.0] tracing: Add refcount for system filter and enable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent

Head SHA1: 57f124ca21d216fca3ba3995235c15855f9b9980


Steven Rostedt (2):
      tracing: Add ref_count to event systems for freeing
      tracing: Have enable system events use the subsystem_open routine

----
 kernel/trace/trace.h               |    1 +
 kernel/trace/trace_events.c        |  113 ++++++++++++++++++++++++++++++------
 kernel/trace/trace_events_filter.c |    6 ++
 3 files changed, 102 insertions(+), 18 deletions(-)
