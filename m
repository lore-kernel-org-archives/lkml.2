Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0IMDYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:24:36 -0400
Received: from ozlabs.org ([203.10.76.45]:54531 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab0IMDYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:24:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: #2 (Re: More modaliases + patchtool)
Date: Mon, 13 Sep 2010 12:54:28 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: mahatma@eu.by, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <4C6BE292.3060307@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au> <20100911175118.GA8521@core.coreip.homeip.net>
In-Reply-To: <20100911175118.GA8521@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131254.28773.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Sep 2010 03:21:19 am Dmitry Torokhov wrote:
> On Sat, Sep 11, 2010 at 11:44:33AM +0930, Rusty Russell wrote:
> > On Thu, 19 Aug 2010 10:12:36 pm Dzianis Kahanovich wrote:
> > > diff -pruN a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> > > --- a/drivers/char/sysrq.c	2010-08-02 01:11:14.000000000 +0300
> > > +++ b/drivers/char/sysrq.c	2010-08-19 15:23:41.444764991 +0300
> > > @@ -799,4 +799,9 @@ static int __init sysrq_init(void)
> > >  
> > >  	return 0;
> > >  }
> > > +
> > > +#ifdef CONFIG_INPUT
> > > +MODULE_DEVICE_TABLE(input, sysrq_ids);
> > > +#endif
> > > +
> > >  module_init(sysrq_init);
> > 
> > Hmm, Dmitry?  Do we want this auto-loaded?
> > 
> 
> Rusty,
> 
> CONFIG_MAGIC_SYSRQ is currently a bool and SysRq support can only be
> built-in.

That seems pretty clear then.

Thanks!
Rusty.
PS. Dmitry, maybe a build with allmodconfig would help eliminate some of
    these?
