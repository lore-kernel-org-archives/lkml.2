Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2HGRqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:46:52 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:8864
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755748Ab2HGRoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:32 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M8EBY4-01-CEO-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/6] perf, tools: Fixes and documentation updates
Date: Tue, 7 Aug 2012 19:43:10 +0200
Message-ID: <1344361396-7237-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some random fixes, esp. build and 32 bit fixes. Also some
documentation updates.

Robert Richter (6):
  perf, tools: Fix version file for perf documentation with OUTPUT
    variable set
  perf, tools: Fix lib/traceevent build dir with OUTPUT variable set
  perf, tools: Fix parsing of 64 bit raw config value for 32 bit
  perf, tools: Fix cast from pointer to integer for 32 bit
  perf, tools: Update documentation about raw event setup
  perf, tools: Document precise event sampling for AMD IBS

 tools/lib/traceevent/event-parse.c     |    3 +-
 tools/perf/Documentation/Makefile      |    6 ++--
 tools/perf/Documentation/perf-list.txt |   48 ++++++++++++++++++++++++--------
 tools/perf/Makefile                    |    8 ++--
 tools/perf/util/parse-events.c         |    6 ++--
 tools/perf/util/parse-events.h         |    6 ++--
 tools/perf/util/parse-events.l         |    4 +-
 tools/perf/util/parse-events.y         |   10 +++---
 8 files changed, 58 insertions(+), 33 deletions(-)

-- 
1.7.8.4


