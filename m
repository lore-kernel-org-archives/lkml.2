Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2HNX1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:27:44 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60682 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab2HNX1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:27:43 -0400
Date: Tue, 14 Aug 2012 16:27:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
Message-ID: <20120814232738.GG25632@google.com>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
 <alpine.LFD.2.02.1208131720070.32033@ionos>
 <20120814191549.GX25632@google.com>
 <alpine.LFD.2.02.1208142118060.32033@ionos>
 <20120814214009.GD25632@google.com>
 <alpine.LFD.2.02.1208150045360.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208150045360.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On Wed, Aug 15, 2012 at 01:12:01AM +0200, Thomas Gleixner wrote:
> Just for the record. The thread evolved from here:
> 
>   <tj>    * mod_delayed_work() can't be used from IRQ handlers.
> 
> My answer was:
> 
>   <tglx>  This function does not exist. So what?
> 
> Which was completely appropriate as this function does not exist
> though you used it as a primary argument for your patches.

I read it as "so, what's wrong with not having mod_delayed_work()?",
so the response.

It exists in wq/for-3.7 and cancel_delayed_work() (the one without
preceding __) + queue() users have been already converted.

  http://thread.gmane.org/gmane.linux.kernel/1334546

> Can you please sit down for a little while and think about your own
> snarkiness and your own tiring behaviour against other kernel
> maintainers?

Believe it or not, I tend to work pretty well with other maintainers
and developers.  You start responding with words like "mess" and
"crap" with condescension sprinkled and expect the conversation to not
escalate?  Let's just stay technical, okay?

Thanks.

-- 
tejun
