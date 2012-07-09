Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2GIOzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:55:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab2GIOze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:55:34 -0400
Message-ID: <4FFAF0A9.7060509@redhat.com>
Date: Mon, 09 Jul 2012 10:54:33 -0400
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
References: <20120316144028.036474157@chello.nl>  <20120316144241.012558280@chello.nl> <4FF9D2EF.7010901@redhat.com> <1341836705.3462.62.camel@twins>
In-Reply-To: <1341836705.3462.62.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 08:25 AM, Peter Zijlstra wrote:
> On Sun, 2012-07-08 at 14:35 -0400, Rik van Riel wrote:
>>
>> This looks like something that should be fixed before the
>> code is submitted for merging upstream.
>
> static bool __task_can_migrate(struct task_struct *t, u64 *runtime, int node)
> {
...
> is what it looks like..

Looks good to me.

-- 
All rights reversed
