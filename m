Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab0FUOvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:51:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab0FUOvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:51:07 -0400
Date: Mon, 21 Jun 2010 10:50:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH] cfq-iosched: Fixed boot warning with BLK_CGROUP=y and
 CFQ_GROUP_IOSCHED=n
Message-ID: <20100621145016.GA4259@redhat.com>
References: <20100618143947.GA8431@redhat.com>
 <20100620081016.GA5365@elte.hu>
 <20100620225622.GA12368@redhat.com>
 <20100621070517.GA31535@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621070517.GA31535@elte.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 09:05:17AM +0200, Ingo Molnar wrote:
> 
> * Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Sun, Jun 20, 2010 at 10:10:16AM +0200, Ingo Molnar wrote:
> > > 
> > > * Vivek Goyal <vgoyal@redhat.com> wrote:
> > > 
> > > > Hi Jens,
> > > > 
> > > > Few days back Ingo noticed a CFQ boot time warning. This patch fixes it.
> > > 
> > > Hm, have you tested it? This bit:
> > 
> > I did compile and boot testing. Booted with CFQ_GROUP_IOSCHED=n to make
> > sure warning seen by you is gone. [...]
> 
> It was not a build warning, it was a build failure. (Even if it built the 
> recursion would cause a crash on bootup.) Will try your newer patch too.

I think compiler is doing some optimizations. On my system, it just
compiles fine and even boots fine. But when I introduce a trace_printk(),
statement in the function, then compilation is fine but system hangs
during boot.

I am using gcc version 4.4.4 20100503.

Thanks
Vivek
