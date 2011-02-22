Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1BVVEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:04:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:9679 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab1BVVEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:04:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,207,1297065600"; 
   d="scan'208";a="711922351"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        richard.purdie@linuxfoundation.org, dvhart@linux.intel.com
Subject: [PATCH 0/2] sched: SCHED_BATCH fixes
Date: Tue, 22 Feb 2011 13:04:32 -0800
Message-Id: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches tweak the scheduling behavior surrounding SCHED_BATCH
tasks slightly. While experimenting on ways to improve performance of a build
system I stumbled across what I thought to be oversights in the implementation.
Specifically with respect to rtprio privileges and batch-idle task interaction.

--
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

