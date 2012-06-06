Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2FFH0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:26:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63178 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2FFH0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:26:03 -0400
Date: Wed, 6 Jun 2012 09:25:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk: Shrink printk_sched buffer size, eliminate it
 when !CONFIG_PRINTK
Message-ID: <20120606072558.GG17808@gmail.com>
References: <1337096141.27694.82.camel@twins>
 <1337193010.27694.146.camel@twins>
 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
 <1337468148.573.139.camel@twins>
 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
 <20120523150359.GB26974@gmail.com>
 <1337787838.1734.15.camel@joe2Laptop>
 <20120523155003.GA8202@gmail.com>
 <1338315431.18974.10.camel@joe2Laptop>
 <1338912268.5780.0.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338912268.5780.0.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Tue, 2012-05-29 at 11:17 -0700, Joe Perches wrote:
> > The size of the per-cpu printk_sched buf is much larger
> > than necessary.  The maximum sched message emitted is
> > ~80 bytes. Shrink the allocation for this printk_sched
> > buffer from 512 bytes to 128.
> > 
> > printk_sched creates an unnecessary per-cpu buffer when
> > CONFIG_PRINTK is not enabled.  Remove it when appropriate
> > so embedded uses save a bit of space too.
> 
> Ingo, what's happening with this patch?

The merge window is a busy period for most maintainers, so 
non-fix patches sent in that period typically get delayed,
to be processed when there's more time available.

Thanks,

	Ingo
