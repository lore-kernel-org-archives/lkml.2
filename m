Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0CYQMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:12:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab0CYQMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:12:14 -0400
Date: Thu, 25 Mar 2010 17:10:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched/cpusets fixes, more changes are needed
Message-ID: <20100325161008.GA11724@redhat.com>
References: <20100315090958.GA9116@redhat.com> <1269452296.5109.508.camel@twins> <20100324180912.GA21774@redhat.com> <1269512531.12097.67.camel@laptop> <20100325154616.GA9773@redhat.com> <20100325160243.GA11517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325160243.GA11517@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh, sorry for noise...

On 03/25, Oleg Nesterov wrote:
>
> On 03/25, Oleg Nesterov wrote:
> >
> > I like the current idea to call select_task_rq() without rq->lock, but
> > of course this is up to you.
> >
> > However, once again, can't we make a simpler patch?
> >
> > 	- remove PF_STARTING from task_waking()
> > 	
> > 	- change sched_fork() to set RUNNING instead of WAKING

When I reread this thread, suddenly finally I noticed you mentioned
_twice_ your patch does this too ;) Not to mention the patch itself
which I misread. Sorry.

> IOW, something like the (unchecked, uncompiled) patch below.

Still, what do you think?

Oleg.

