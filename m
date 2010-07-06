Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0GFSIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:08:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35576 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab0GFSH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A3sgBghQ44rDkfjJJzWw+GT9hfJEdrsBoaTNiuUqkML3YLk9IY9tVk6atJ4dblQAZB
         DIdy6+SwNfD7LtjNxL9yJ19iSJUUzCT9roXbw1riYlrwXkAXoztCJ+Yw6tIlRj3ImhW/
         Wdxsx1mjwY7LOUu8ZzUL/BXZ3R2d9Mx3E/V/I=
Subject: Re: [PATCH] Staging: dt3155: fix coding style issues in
 dt3155_drv.c
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Aldo Cedillo <aldobrett11@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>, devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTingSXbyFclWga9x5aD7MoccCMqhu56PCOVTKHVJ@mail.gmail.com>
References: <1278435198.5396.73.camel@dermezel>
	 <AANLkTingSXbyFclWga9x5aD7MoccCMqhu56PCOVTKHVJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 19:37:30 +0200
Message-ID: <1278437850.5396.85.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 12:25 -0500, Aldo Cedillo wrote:
> > diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
> > index 66db878..f6edd66 100644
> > --- a/drivers/staging/dt3155/dt3155_drv.c
> > +++ b/drivers/staging/dt3155/dt3155_drv.c
> > @@ -308,33 +308,42 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
> >  #endif
> >                        if (fb->nbuffers > 2) {
> >                                if (!are_empty_buffers(minor)) {
> > -                                       /* The number of active + locked buffers is
> > -                                        * at most 2, and since there are none empty, there
> > -                                        * must be at least nbuffers-2 ready buffers.
> > -                                        * This is where we 'drop frames', oldest first. */
> > +                                       /* The number of active +
> > +                                        * locked buffers is at most 2,
> > +                                        * and since there are none empty,
> > +                                        * there must be at least nbuffers-2
> > +                                        * ready buffers.
> > +                                        * This is where we 'drop frames',
> > +                                        * oldest first. */
> >                                        push_empty(pop_ready(minor),  minor);
> >                                }
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
> 
> Thanks,
> Aldo Brett

I presumed all issues would be incorporated into checkpatch.pl. I guess
it isn't.
I think the safest be here then would be to fix the script as to then
have a single point of failure rather than interpretation and reference
documentation in conjunction to the script.

Regards,

Joe



