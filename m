Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab0LQS3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:29:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab0LQS3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:29:06 -0500
Date: Fri, 17 Dec 2010 19:21:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
Message-ID: <20101217182154.GA12817@redhat.com>
References: <20101216145602.899838254@chello.nl> <20101216150920.968046926@chello.nl> <20101216184229.GA15889@redhat.com> <1292525893.2708.50.camel@laptop> <1292526220.2708.55.camel@laptop> <1292528874.2708.85.camel@laptop> <1292531553.2708.89.camel@laptop> <20101217165414.GA8997@redhat.com> <1292607781.2266.295.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292607781.2266.295.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17, Peter Zijlstra wrote:
>
> Hrmph, so is it only about serializing concurrent wakeups?

I __think__ that it is possible to solve other problems, but
of course I am not sure ;)

> If so, we
> could possibly hold p->pi_lock over the wakeup.

Hmm, yes, this looks right.

Oleg.

