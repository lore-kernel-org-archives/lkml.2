Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab0DVEXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 00:23:06 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:35934 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0DVEXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 00:23:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=esq6exSGyrohmPfsNkSBOj5xcSEM0gpvY/+YS3rT2ZB5YVpIA4/9yYemSOkWNvvhOg
         wHATpXZbx3fFzZ+0BKDF8GEf04kmkD797N2SejyEcThupYVpS38n0n/gs7nBDA1sGFYh
         l560jluZqcQzG93D4iE4Tnkspcxz2SoA5Wc+I=
MIME-Version: 1.0
In-Reply-To: <1271908811.1730.613.camel@Joe-Laptop.home>
References: <1271907971-8793-1-git-send-email-silvagustavo@users.sourceforge.net>
	 <1271908811.1730.613.camel@Joe-Laptop.home>
Date: Wed, 21 Apr 2010 23:23:01 -0500
Message-ID: <o2x7470ede81004212123qe02e9870i534829a224c05585@mail.gmail.com>
Subject: Re: [PATCH] Staging: Comedi: Drivers: Fix coding style issues in 
	dt2801.c
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/21 Joe Perches <joe@perches.com>
>
> On Wed, 2010-04-21 at 22:46 -0500, Gustavo Silva wrote:
> >  drivers/staging/comedi/drivers/dt2801.c |  100 ++++++++++++++-----------------
> >  1 files changed, 44 insertions(+), 56 deletions(-)
>
> Hi Gustavo.  A couple of trivial comments.
>
> > diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
> > index 3f365ae..c4408d8 100644
> > --- a/drivers/staging/comedi/drivers/dt2801.c
> > +++ b/drivers/staging/comedi/drivers/dt2801.c
> > @@ -102,58 +102,46 @@ COMEDI_INITCLEANUP(driver_dt2801);
> >
> >  #if 0
>
> You could just as well remove the #if 0 blocks
>
> > @@ -374,8 +362,8 @@ static int dt2801_writecmd(struct comedi_device *dev, int command)
> >
> >       stat = inb_p(dev->iobase + DT2801_STATUS);
> >       if (stat & DT_S_COMPOSITE_ERROR) {
> > -             printk
> > -                 ("dt2801: composite-error in dt2801_writecmd(), ignoring\n");
> > +             printk(KERN_INFO "dt2801: composite-error in dt2801_writecmd()"
> > +                                                             ", ignoring\n");
>
> It's good to preface with KERN_, but better might be to use
>        #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> and strip the "dt2801: " intro and use
>        pr_<level>("%s(): composite-error, ignoring\n", __func__)
>
> It's a bit shorter, always gets the appropriate prefix, and
> would emit the proper function name if ever refactored.
>
> cheers, Joe
>

Hi Joe!

Thank you very much for your comments.

I will put in practice what you suggest.

No comment is trivial when it comes to help. :-]

Cheers from Mexico!
Gustavo Silva.
