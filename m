Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab1F3ID5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:03:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:12112 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586Ab1F3IDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:03:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,449,1304319600"; 
   d="scan'208";a="20764670"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] perf: Intel uncore pmu counting support
Date: Thu, 30 Jun 2011 08:09:52 +0000
Message-Id: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I posted uncore patches months ago, but it was pended due to an uncore
interrupt problem.

This series are cut to support uncore pmu counting only.
So uncore interrupt handling is not needed.

The uncore pmu type is allocated dynamically and exported via sysfs.
$ cat /sys/bus/event_source/devices/uncore/type
6

You can count uncore raw events as below,
$ perf stat -e uncore:r0101 ls

It reads uncore pmu type id from sysfs to setup perf_event_attr::type.

Comments are appreciated.

Thanks,
Lin Ming

