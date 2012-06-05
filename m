Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2FEQEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:04:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41189 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751474Ab2FEQEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:04:30 -0400
Message-ID: <1338912268.5780.0.camel@joe2Laptop>
Subject: Re: [PATCH] printk: Shrink printk_sched buffer size, eliminate it
 when !CONFIG_PRINTK
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Jun 2012 09:04:28 -0700
In-Reply-To: <1338315431.18974.10.camel@joe2Laptop>
References: <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins> <1337193010.27694.146.camel@twins>
	 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
	 <1337468148.573.139.camel@twins>
	 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
	 <20120523150359.GB26974@gmail.com> <1337787838.1734.15.camel@joe2Laptop>
	 <20120523155003.GA8202@gmail.com> <1338315431.18974.10.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 11:17 -0700, Joe Perches wrote:
> The size of the per-cpu printk_sched buf is much larger
> than necessary.  The maximum sched message emitted is
> ~80 bytes. Shrink the allocation for this printk_sched
> buffer from 512 bytes to 128.
> 
> printk_sched creates an unnecessary per-cpu buffer when
> CONFIG_PRINTK is not enabled.  Remove it when appropriate
> so embedded uses save a bit of space too.

Ingo, what's happening with this patch?


