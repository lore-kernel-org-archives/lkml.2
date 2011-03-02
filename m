Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab1CBR3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:29:13 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:24921 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1CBR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:29:10 -0500
X-IronPort-AV: E=Sophos;i="4.62,254,1297036800"; 
   d="scan'208";a="337912120"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 0/3] perf script: add support for S/W events and H/W based profiling
Date: Wed,  2 Mar 2011 10:29:17 -0700
Message-Id: <1299086960-26964-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pulling this part of the time-of-day series since the functionality is
independent.

David Ahern (3):
  perf script: change process_event prototype
  perf script: prepare to handle more than tracepoint events
  perf script: dump software events and samples from hardware-based
    profiling

 tools/perf/Documentation/perf-script.txt           |   19 +++
 tools/perf/builtin-script.c                        |  118 ++++++++++++++-----
 .../util/scripting-engines/trace-event-python.c    |   20 +++-
 tools/perf/util/session.c                          |  113 +++++++++++++++++++
 tools/perf/util/session.h                          |    6 +
 tools/perf/util/trace-event-parse.c                |    4 +-
 tools/perf/util/trace-event-scripting.c            |    8 +-
 tools/perf/util/trace-event.h                      |   10 +-
 8 files changed, 253 insertions(+), 45 deletions(-)

-- 
1.7.4

