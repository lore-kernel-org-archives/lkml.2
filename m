Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2GDP3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:29:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47386 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2GDP3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:29:10 -0400
Subject: Re: [PATCH 03/16] sched: aggregate load contributed by task
 entities on parenting cfs_rq
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <20120628022414.30496.73426.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022414.30496.73426.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 17:28:46 +0200
Message-ID: <1341415726.19870.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:
> For a given task t, we can compute its contribution to load as:
>   task_load(t) = runnable_avg(t) * weight(t)
> 
> On a parenting cfs_rq we can then aggregate
>   runnable_load(cfs_rq) = \Sum task_load(t), for all runnable children t
> 
> Maintain this bottom up, with task entities adding their contributed load to
> the parenting cfs_rq sum.  When a task entities load changes we add the same
> delta to the maintained sum.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Ben Segall <bsegall@google.com> 

A lot of patches have this funny sob trail.. Ben never send me these
patches, so uhm. ?

Should that be Reviewed-by, or what is the deal with those?

