Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab1AZBPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 20:15:17 -0500
Received: from mail.perches.com ([173.55.12.10]:3367 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1AZBPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 20:15:15 -0500
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
From: Joe Perches <joe@perches.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
In-Reply-To: <20110126010137.GS8008@google.com>
References: <20110125235700.GR8008@google.com>
	 <1296002449.6115.9.camel@Joe-Laptop>  <20110126010137.GS8008@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 17:15:14 -0800
Message-ID: <1296004514.6115.16.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 17:01 -0800, Mandeep Singh Baines wrote:
> Joe Perches (joe@perches.com) wrote:
> > On Tue, 2011-01-25 at 15:57 -0800, Mandeep Singh Baines wrote:
> > > To make it easier to audit dmesg, we'd like to make
> > > DEFAULT_MESSAGE_LEVEL Kconfig-settable. That way we can set it to
> > > KERN_NOTICE and audit any messages <= KERN_WARNING.
> > Seems sensible, but mightn't it be better to make sure
> > that all printks use a specific KERN_<level> rather
> > than check that printks without a KERN_<level> are
> > emitted at a selectable level?
> Can we do both?

As far as I'm concerned, yes.

> I was planning sending cleanup patches as well but expected
> that process to take a while.

True.

Perhaps you could do printk()->pr_<level> (dev_<level>/netdev_>level>)
conversions as appropriate as well.

> The correct thing would be to set each printk to an appropriate level.
> Determining appropriate level will take some discussion (so a long term
> project).

My EDC/ECD is: a long time from now.  Maybe.


