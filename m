Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab2EWP4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:56:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56719 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751876Ab2EWP4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:56:10 -0400
Message-ID: <1337788569.1734.19.camel@joe2Laptop>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Chen <hi3766691@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 08:56:09 -0700
In-Reply-To: <20120523155003.GA8202@gmail.com>
References: <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins> <1337193010.27694.146.camel@twins>
	 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
	 <1337468148.573.139.camel@twins>
	 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
	 <20120523150359.GB26974@gmail.com> <1337787838.1734.15.camel@joe2Laptop>
	 <20120523155003.GA8202@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 17:50 +0200, Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> > In a 1000 cpu config, there also an extra 500+ bytes per cpu
> > in printk (I don't think that's particularly important btw)
> A 1000 cpu piece of hardware will have a terabyte of RAM or 
> more. 0.5K per CPU is reasonable.

That's not fundamentally true, but it's not
particularly important right now either.

cheers, Joe

