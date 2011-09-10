Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab1IJOyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 10:54:39 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:47052
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933349Ab1IJOye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 10:54:34 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eKzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRBAQN-02-22P-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] perf, x86: handle overlapping counters
Date: Sat, 10 Sep 2011 16:49:01 +0200
Message-ID: <1315666143-7106-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set implements support for overlapping counters (patch #2).
For this the existing x86 event scheduler is reworked by introducing
helper functions (patch #1).

-Robert


The following changes since commit 51887c8230d57c4d9cc68e3784c52c8f0a708655:

  Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2011-08-18 21:58:46 +0200)

Robert Richter (2):
      perf, x86: Implement event scheduler helper functions
      perf, x86: Fix event scheduler for constraints with overlapping counters

 arch/x86/kernel/cpu/perf_event.c     |  234 ++++++++++++++++++++++++++--------
 arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
 2 files changed, 179 insertions(+), 57 deletions(-)


