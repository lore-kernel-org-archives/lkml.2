Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2LCNyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:54:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:8866 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab2LCNyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:54:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,206,1355126400"; 
   d="scan'208";a="258228946"
From: Alex Shi <alex.shi@intel.com>
To: npiggin@kernel.dk, mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/4] sched: fork/exec/wake clean up
Date: Mon,  3 Dec 2012 21:54:04 +0800
Message-Id: <1354542848-29638-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset try to clean up select_task_rq_fair which used for 
fork/exec/wake scheduling.

With this patchset, our system NHM EX and SNB EP 4 socket machine
has 10% hackbench performance increase.

Regards
Alex

[PATCH 01/4] sched: select_task_rq_fair clean up
[PATCH 02/4] sched: fix find_idlest_group mess logical
[PATCH 03/4] sched: don't need go to smaller sched domain
[PATCH 04/4] sched: remove domain iterations in fork/exec/wake
