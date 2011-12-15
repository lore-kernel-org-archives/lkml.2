Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab1LOQlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:41:32 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:50977
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932558Ab1LOQl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:41:29 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW97AU-02-98J-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/4] perf tools: More fixes and updates
Date: Thu, 15 Dec 2011 17:32:38 +0100
Message-ID: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more fixes and updates for perf tools.

Robert Richter (4):
  perf tools: Fix uninitialized memory access to struct perf_sample
  perf record: Make feature initialization generic
  perf tools: Moving code in header.c
  perf tools: Factor out feature op to process header sections

 tools/perf/builtin-record.c |   28 +---
 tools/perf/util/evsel.c     |    2 +-
 tools/perf/util/header.c    |  344 ++++++++++++++++++++++---------------------
 tools/perf/util/header.h    |    1 +
 4 files changed, 190 insertions(+), 185 deletions(-)

-- 
1.7.7


