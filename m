Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2DEQ0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:26:40 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:58120 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287Ab2DEQ0i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:26:38 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h93fhd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20LO9-01-4MW-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/4] perf tools: Some fixes and updates
Date: Thu, 5 Apr 2012 18:26:24 +0200
Message-ID: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclosed some changes made while working with the code. Mostly trivial
but worth to add.

-Robert


Robert Richter (4):
  perf tools: Fix include header files in util/parse-events.h
  perf tools: Fix thread map that is type pid_t
  perf tools: Declare some references static in builtin-stat.c
  perf tools: Use sw counter only if hw pmu is not detected

 tools/perf/builtin-record.c    |    2 +-
 tools/perf/builtin-stat.c      |   26 +++++++++++++-------------
 tools/perf/util/parse-events.h |    2 ++
 tools/perf/util/thread_map.h   |    2 +-
 4 files changed, 17 insertions(+), 15 deletions(-)

-- 
1.7.8.4


