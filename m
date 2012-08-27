Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2H0HoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:44:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:49807 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab2H0HoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:44:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,318,1344236400"; 
   d="scan'208";a="138220449"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 0/3] perf tools: Fixes for some compile errors. 
Date: Mon, 27 Aug 2012 15:38:24 +0800
Message-Id: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and all,

I met 3 compiling problems on my x86_32 machine, and these are the fixes,
patch 1/3 only applies for perf/core branch of your git, while patch 2
applies to Linus' tree also. please review.

Thanks,
Feng

---
Feng Tang (3):
  perf tools: Fix a compiling error in trace-event-perl.c for 32 bits
    machine
  Perf tools: Fix a compiling error in util/map.c
  perf tools: Fix a misuse of for_each_set_bit() in session.c

 tools/perf/util/map.c                              |    5 ++---
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 tools/perf/util/session.c                          |    9 ++++-----
 3 files changed, 7 insertions(+), 9 deletions(-)

