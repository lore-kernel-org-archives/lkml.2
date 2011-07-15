Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1GOO3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:29:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:53067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1GOO3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:29:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,535,1304319600"; 
   d="scan'208";a="26267099"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/6] perf: Intel uncore pmu counting support
Date: Fri, 15 Jul 2011 14:34:57 +0000
Message-Id: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

This is the v2 patches to support uncore pmu counting.
The most important change is to use hrtimer to pull uncore counters
to handle overflow, because uncore pmu interrupt does not work.

v2 -> v1:
- Use hrtimer to pull counters
- Add interface to add general events to sysfs
- Move MSRs to msr-index.h
- Add uncore fixed counter
- Allow system-wide 'perf stat' without 'command'

Comments are appreciated.

Thanks,
Lin Ming

