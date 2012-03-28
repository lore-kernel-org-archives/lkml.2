Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2C1GnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:43:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:25773 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab2C1GnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:43:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="82461614"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: [RFC PATCH 0/5] perf: Intel uncore pmu counting support
Date: Wed, 28 Mar 2012 14:43:13 +0800
Message-Id: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Here is the RFC patches to add uncore counting support for Nehalem,
Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
The code is based on Lin Ming's old patches.

You can use 'perf stat' to access to the uncore pmu. For example:
perf stat -a -C 0 -e 'uncore_nhm/config=0xffff/' sleep 1

For Nehalem and Sandy Bridge-EP, A few general events are exported
under directory:
/sys/bus/event_source/devices/uncore_xxx/events/

Any comment is appreciated.
Thank you

