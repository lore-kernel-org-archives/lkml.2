Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab1LBV7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 16:59:18 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:19321 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab1LBV7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 16:59:17 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl
Subject: [PATCH 0/2] Fix brown paper bag bugs on previous submission
Date: Fri,  2 Dec 2011 19:58:37 -0200
Message-Id: <1322863119-14225-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Now that I rebased to your queue tree and put my other patches ontop
of it, I noticed two quite stupid bug I've made in the last series you
merged.

In the end, one of them masked the other: one of them causes us to double
account to the root cgroup, the other, sends one of the accounting to the 
wrong place.

Would you please add on top of what you have?

Glauber Costa (2):
  Fix user/system tick double accounting
  fix parameter passing in task_group_account_field

 kernel/sched/core.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

-- 
1.7.6.4

