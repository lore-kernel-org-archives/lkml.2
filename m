Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab2EWP7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:59:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65205 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab2EWP7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:59:33 -0400
Date: Wed, 23 May 2012 17:59:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Chen <hi3766691@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Message-ID: <20120523155926.GA32340@gmail.com>
References: <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
 <1337096141.27694.82.camel@twins>
 <1337193010.27694.146.camel@twins>
 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
 <1337468148.573.139.camel@twins>
 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
 <20120523150359.GB26974@gmail.com>
 <1337787838.1734.15.camel@joe2Laptop>
 <20120523155003.GA8202@gmail.com>
 <1337788569.1734.19.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337788569.1734.19.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-05-23 at 17:50 +0200, Ingo Molnar wrote:
> > * Joe Perches <joe@perches.com> wrote:
> > >
> > > In a 1000 cpu config, there also an extra 500+ bytes per cpu
> > > in printk (I don't think that's particularly important btw)
> >
> > A 1000 cpu piece of hardware will have a terabyte of RAM or 
> > more. 0.5K per CPU is reasonable.
> 
> That's not fundamentally true, [...]

Compared to the known alternatives it's pretty fundamentally 
true.

Thanks,

	Ingo
