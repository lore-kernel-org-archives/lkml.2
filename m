Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2HNXqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:46:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:33888 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2HNXqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:46:17 -0400
Date: Wed, 15 Aug 2012 01:46:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
In-Reply-To: <20120814232738.GG25632@google.com>
Message-ID: <alpine.LFD.2.02.1208150134070.32033@ionos>
References: <1344449428-24962-1-git-send-email-tj@kernel.org> <alpine.LFD.2.02.1208131720070.32033@ionos> <20120814191549.GX25632@google.com> <alpine.LFD.2.02.1208142118060.32033@ionos> <20120814214009.GD25632@google.com> <alpine.LFD.2.02.1208150045360.32033@ionos>
 <20120814232738.GG25632@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Tue, 14 Aug 2012, Tejun Heo wrote:
> On Wed, Aug 15, 2012 at 01:12:01AM +0200, Thomas Gleixner wrote:
> > Just for the record. The thread evolved from here:
> > 
> >   <tj>    * mod_delayed_work() can't be used from IRQ handlers.
> > 
> > My answer was:
> > 
> >   <tglx>  This function does not exist. So what?
> > 
> > Which was completely appropriate as this function does not exist
> > though you used it as a primary argument for your patches.
> 
> I read it as "so, what's wrong with not having mod_delayed_work()?",
> so the response.

Oh well. Your interpretation of "So what?" starts to stress my
patience.

> It exists in wq/for-3.7 and cancel_delayed_work() (the one without
> preceding __) + queue() users have been already converted.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1334546

Do you really expect that I follow all of kernel dev posts within a
day of returning from a two weeks vacation?

Thanks,

	tglx
