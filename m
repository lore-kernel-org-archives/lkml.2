Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab1IHGA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 02:00:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:48915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab1IHGA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 02:00:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,349,1312182000"; 
   d="scan'208";a="50364498"
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH -mm -v2 0/5] irq_work, Use llist in irq_work
Date: Thu,  8 Sep 2011 14:00:41 +0800
Message-Id: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

v2:

- Return whether list is empty before adding in llist_add and use that in
  __irq_work_queue

[PATCH -mm -v2 1/5] llist, Make all llist functions inline
[PATCH -mm -v2 2/5] llist, Define macro to check NMI safe cmpxchg
[PATCH -mm -v2 3/5] llist, Move cpu_relax after cmpxchg
[PATCH -mm -v2 4/5] llist, Return whether list is empty before adding in llist_add
[PATCH -mm -v2 5/5] irq_work, Use llist in irq_work
