Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2INFsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:48:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:23161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab2INFsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:48:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,421,1344236400"; 
   d="scan'208";a="203627521"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] few functions clean up
Date: Fri, 14 Sep 2012 13:47:22 +0800
Message-Id: <1347601645-20139-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed according to Peter and Suresh suggestion.

Thanks
[PATCH v2 1/3] nohz: clean up select_nohz_load_balancer()
[PATCH v2 2/3] sched:nohz rename clear_nohz_tick_stopped as
[PATCH v2 3/3] sched/balance: remove on_null_domain() in
