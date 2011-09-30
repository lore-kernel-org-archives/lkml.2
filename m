Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab1I3DzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:55:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47180 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab1I3DzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:55:05 -0400
Date: Thu, 29 Sep 2011 20:55:01 -0700
From: Tejun Heo <htejun@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
Message-ID: <20110930035501.GG10425@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317158254.26514.55.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 05:17:34PM -0400, Steven Rostedt wrote:
> For convenience and optimization, we are going to use the task's flag
> PF_THREAD_BOUND as a way to know if a task is bound to a CPU or not. As
> that is what the flag means.

And I'm not sure this is a very good idea.  Until now, PF_THREAD_BOUND
meant "this task is explicitly bound to the current affinity (whatever
it is) and thus it shouldn't be manipulated by third party".  The
suggested change makes the flag much less orthogonal and useful.  How
much of convenience and optimization are we talking about?

Thanks.

-- 
tejun
