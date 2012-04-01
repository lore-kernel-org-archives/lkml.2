Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2DABln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 21:41:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:24290 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab2DABlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 21:41:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125662179"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: [RFC PATCH V2 0/6] perf: Intel uncore pmu counting support
Date: Sun,  1 Apr 2012 09:41:29 +0800
Message-Id: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Here is the RFC patches to add uncore counting support for Nehalem,
Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
The code is based on Lin Ming's old patches.

For Nehalem and Sandy Bridge-EP, A few general events are exported
under directory:
/sys/bus/event_source/devices/uncore_xxx/events/

You can use 'perf stat' to access to the uncore pmu. For example:
perf stat -a -C 0 -e 'uncore_nhm/QMC_WRITES_FULL_ANY/' sleep 1

Any comment is appreciated.
Thank you

---
Changes since v1:
 - Modify perf tool to parse events from sysfs
 - A few minor code cleanup

