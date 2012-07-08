Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab2GHSgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 14:36:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab2GHSgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:36:10 -0400
Message-ID: <4FF9D2EF.7010901@redhat.com>
Date: Sun, 08 Jul 2012 14:35:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 14/26] sched, numa: Numa balancer
References: <20120316144028.036474157@chello.nl> <20120316144241.012558280@chello.nl>
In-Reply-To: <20120316144241.012558280@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 10:40 AM, Peter Zijlstra wrote:

+static bool can_move_ne(struct numa_entity *ne)
+{
+	/*
+	 * XXX: consider mems_allowed, stinking cpusets has mems_allowed
+	 * per task and it can actually differ over a whole process, la-la-la.
+	 */
+	return true;
+}

This looks like something that should be fixed before the
code is submitted for merging upstream.

-- 
All rights reversed
