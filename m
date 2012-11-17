Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab2KQNEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 08:04:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:12915 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab2KQNEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 08:04:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,270,1352102400"; 
   d="scan'208";a="219067065"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] enable runnable load avg in load balance
Date: Sat, 17 Nov 2012 21:04:12 +0800
Message-Id: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset try to consider runnable load avg when do cpu load comparison
in load balance.

I had seen preeti's enabling before patch finished, but I still think considing
runnable load avg on rq is may a more natrual way.

BTW, I am thinking if 2 times decay for cpu_load is too complicate? one for
runnable time, another for CPU_LOAD_IDX. I think I missed the decay reason
for CPU_LOAD_IDX. Could anyone like do me favor to give some hints of this?

Best Regards!
Alex 

[RFC PATCH 1/5] sched: get rq runnable load average for load balance
[RFC PATCH 2/5] sched: update rq runnable load average in time
[RFC PATCH 3/5] sched: using runnable load avg in cpu_load and
[RFC PATCH 4/5] sched: consider runnable load average in wake_affine
[RFC PATCH 5/5] sched: revert 'Introduce temporary FAIR_GROUP_SCHED
