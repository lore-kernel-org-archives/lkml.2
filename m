Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2GDGAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:00:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:28581 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab2GDGAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:00:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163860350"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] perf/x86: Uncore updates
Date: Wed,  4 Jul 2012 14:00:11 +0800
Message-Id: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

This series of patches consist of update/fix for the uncore driver.
The 1st, 2nd and the 4th patches are resending of old ones. The 3rd
patch fixes a bug that may cause GP fault on some types of CPU. The
5th patch adds Nehalem-EX uncore support.

Regards
Yan, Zheng

 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 1329 +++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  219 ++-
 2 files changed, 1471 insertions(+), 77 deletions(-)

