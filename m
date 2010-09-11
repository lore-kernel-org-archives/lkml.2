Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0IKRv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 13:51:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37430 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0IKRv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 13:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sMu/0T7l+5YmPOrogf7QG2L2iIbHh+ceHeM2KEzzOe3ooKUdKQCKiy/qUt9Jx6BvoU
         Y+kWxdU+36XtQDxThaGZ+H57y7pp5FYoq/s4UIaN08kncIAov0JjI+Bf7Clof2Jh1xao
         /zHZDspes/cPkCQn3Q+cu9Ri22AOjGCStQaZI=
Date: Sat, 11 Sep 2010 10:51:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mahatma@eu.by, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: #2 (Re: More modaliases + patchtool)
Message-ID: <20100911175118.GA8521@core.coreip.homeip.net>
References: <4C6BE292.3060307@bspu.unibel.by>
 <201008191020.52861.rusty@rustcorp.com.au>
 <4C6D26BC.9040805@bspu.unibel.by>
 <201009111144.34078.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 11:44:33AM +0930, Rusty Russell wrote:
> On Thu, 19 Aug 2010 10:12:36 pm Dzianis Kahanovich wrote:
> > diff -pruN a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> > --- a/drivers/char/sysrq.c	2010-08-02 01:11:14.000000000 +0300
> > +++ b/drivers/char/sysrq.c	2010-08-19 15:23:41.444764991 +0300
> > @@ -799,4 +799,9 @@ static int __init sysrq_init(void)
> >  
> >  	return 0;
> >  }
> > +
> > +#ifdef CONFIG_INPUT
> > +MODULE_DEVICE_TABLE(input, sysrq_ids);
> > +#endif
> > +
> >  module_init(sysrq_init);
> 
> Hmm, Dmitry?  Do we want this auto-loaded?
> 

Rusty,

CONFIG_MAGIC_SYSRQ is currently a bool and SysRq support can only be
built-in.

Thanks.

-- 
Dmitry
