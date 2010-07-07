Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0GGAsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:48:46 -0400
Received: from koto.vergenet.net ([210.128.90.7]:49947 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab0GGAsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:48:45 -0400
Date: Wed, 7 Jul 2010 09:48:42 +0900
From: Simon Horman <horms@verge.net.au>
To: Aldo Cedillo <aldobrett11@gmail.com>
Cc: kagen101@gmail.com, Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: dt3155: fix coding style issues in
 dt3155_drv.c
Message-ID: <20100707004841.GA28188@verge.net.au>
References: <1278435198.5396.73.camel@dermezel>
 <AANLkTingSXbyFclWga9x5aD7MoccCMqhu56PCOVTKHVJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTingSXbyFclWga9x5aD7MoccCMqhu56PCOVTKHVJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 12:25:35PM -0500, Aldo Cedillo wrote:
> > diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
> > index 66db878..f6edd66 100644
> > --- a/drivers/staging/dt3155/dt3155_drv.c
> > +++ b/drivers/staging/dt3155/dt3155_drv.c
> > @@ -308,33 +308,42 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
> >  #endif
> >                        if (fb->nbuffers > 2) {
> >                                if (!are_empty_buffers(minor)) {
> > -                                       /* The number of active + locked buffers is
> > -                                        * at most 2, and since there are none empty, there
> > -                                        * must be at least nbuffers-2 ready buffers.
> > -                                        * This is where we 'drop frames', oldest first. */
> > +                                       /* The number of active +
> > +                                        * locked buffers is at most 2,
> > +                                        * and since there are none empty,
> > +                                        * there must be at least nbuffers-2
> > +                                        * ready buffers.
> > +                                        * This is where we 'drop frames',
> > +                                        * oldest first. */
> >                                        push_empty(pop_ready(minor),  minor);
> >                                }
> >
> 
> In the CodingStyle in the kernel you can read:
> 
> The preferred style for long (multi-line) comments is:
> 
>         /*
>          * This is the preferred style for multi-line
>          * comments in the Linux kernel source code.
>          * Please use it consistently.
>          *
>          * Description:  A column of asterisks on the left side,
>          * with beginning and ending almost-blank lines.
>          */
> 
> Again I ask about the coding style because I have seen in many parts of the
> kernel I've seen discrepancies with what is said in the CodingStyle file. So
> I want to get it clear maybe I can help to clean those things.

I believe that you will find both of the following styles in abundance
and that both are acceptable.

   /*
    * This
    * is a multi-line comment
    */

And

   /* This
    * is a also multi-line comment
    */

Though one may be more acceptable to a given maintainer than the other.
Other variants may also be common and acceptable to some maintainers,
which I suspect is why checkpatch.pl is lenient.

