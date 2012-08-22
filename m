Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab2HVHHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:07:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59969 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab2HVHHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:07:20 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-e4-50348525c936
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] tools lib traceevent: Basic error handling
Date: Wed, 22 Aug 2012 16:00:27 +0900
Message-Id: <1345618831-9148-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I almost forgot that I have some libtraceevent patch left. ;)  The
first three of them are acked by Steven and the last is a port of a
recent perf patch from Kirill that handles a strerror_r build warning.
Please consider applying.

Thanks,
Namhyung


Namhyung Kim (4):
  tools lib traceevent: Do not link broken field arg for an old ftrace event
  tools lib traceevent: Introduce pevent_errno
  tools lib traceevent: Introduce pevent_strerror
  tools lib traceevent: Fix strerror_r() use in pevent_strerror

 tools/lib/traceevent/event-parse.c | 104 +++++++++++++++++++++++++++++--------
 tools/lib/traceevent/event-parse.h |  34 +++++++++++-
 tools/lib/traceevent/event-utils.h |   6 +++
 3 files changed, 119 insertions(+), 25 deletions(-)

-- 
1.7.11.4

