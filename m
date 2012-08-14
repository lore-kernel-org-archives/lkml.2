Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2HNXMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:12:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:33748 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2HNXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:12:08 -0400
Date: Wed, 15 Aug 2012 01:12:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
In-Reply-To: <20120814214009.GD25632@google.com>
Message-ID: <alpine.LFD.2.02.1208150045360.32033@ionos>
References: <1344449428-24962-1-git-send-email-tj@kernel.org> <alpine.LFD.2.02.1208131720070.32033@ionos> <20120814191549.GX25632@google.com> <alpine.LFD.2.02.1208142118060.32033@ionos> <20120814214009.GD25632@google.com>
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
> On Tue, Aug 14, 2012 at 10:43:30PM +0200, Thomas Gleixner wrote:
> > > It makes the workqueue users messy.  It's difficult to get completely
> > > correct and subtle errors are difficult to detect / verify.
> > 
> > Ah, the function which does not exist makes the users
> > messy. Interesting observation.
> 
> Can we get a little less snarky please?  It's tiring.

Can you please try to answer my questions instead of throwing random
blurb into my direction?

Just for the record. The thread evolved from here:

  <tj>    * mod_delayed_work() can't be used from IRQ handlers.

My answer was:

  <tglx>  This function does not exist. So what?

Which was completely appropriate as this function does not exist
though you used it as a primary argument for your patches.

Now your answer to my reply was:

  <tj>    It makes the workqueue users messy.  It's difficult to get
          completely correct and subtle errors are difficult to
          detect / verify.

Can you please point out any relevance to my question which would have
me prevented from writing the following?

  <tglx>  Ah, the function which does not exist makes the users
  	  messy. Interesting observation.

So instead of saying, that you wrote an utter nonsense reply you
accuse me of being obnoxious:

  <tj>    Can we get a little less snarky please?  It's tiring.

Can you please sit down for a little while and think about your own
snarkiness and your own tiring behaviour against other kernel
maintainers?

Thanks,

	tglx
