Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2JFALg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 20:11:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:22716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab2JFALe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 20:11:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="202279092"
From: Andi Kleen <andi@firstfloor.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <dhillf@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Dan Smith <danms@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Christoph Lameter <cl@linux.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Alex@linux.intel.com,
        Sh@linux.intel.com
Subject: Re: [PATCH 00/33] AutoNUMA27
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com>
	<20121004113943.be7f92a0.akpm@linux-foundation.org>
	<m24nm8wly3.fsf@firstfloor.org>
	<1349481433.17632.62.camel@schen9-DESK>
Date: Fri, 05 Oct 2012 17:11:33 -0700
In-Reply-To: <1349481433.17632.62.camel@schen9-DESK> (Tim Chen's message of
	"Fri, 05 Oct 2012 16:57:13 -0700")
Message-ID: <m2zk40v4qy.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen <tim.c.chen@linux.intel.com> writes:
>> 
>
> I remembered that 3 months ago when Alex tested the numa/sched patches
> there were 20% regression on SpecJbb2005 due to the numa balancer.

20% on anything sounds like a show stopper to me.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
