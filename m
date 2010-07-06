Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0GFSbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:31:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33674 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0GFSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hkMDCjX21XQg74GurFfzFiD3kJdWLEewGRx8nOa13K7LSDOwLT3S4h1doFTi5d/SwZ
         Bag7Cdyd8zIXBmeSNstWLNCSBABOBRrpkF4zoLC7lJH4RrvzwvKdotppYSo+GNgPH0nl
         8R26Pcqjy6CgOSYq0pHpDmqg2ZF6LdwmJf8Jk=
Subject: Re: [PATCH] Staging: cx25821: fix brace coding style issue in 
 cx25821-audio-upstream.c
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Aldo Cedillo <aldobrett11@gmail.com>
Cc: gregkh@suse.de, mchehab@redhat.com, olimpiu.pascariu@gmail.com,
       julia@diku.dk, tj@kernel.org, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTil_Pu76aEje-5FP9nmxba--pmmAX3YkqNdzN3xX@mail.gmail.com>
References: <1278238174.17566.4.camel@dermezel>
	 <AANLkTil_Pu76aEje-5FP9nmxba--pmmAX3YkqNdzN3xX@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 19:24:44 +0200
Message-ID: <1278437084.5396.81.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 12:12 -0500, Aldo Cedillo wrote:
> > Subject: [PATCH] Staging: cx25821: fix brace coding style issue in cx25821-audio-upstream.c
> >  This is a patch to the cx25821.c file that fixes up a brace warning found by the checkpatch.pl tool
> >  Signed-off-by: Joe Eloff <kagen101@gmail.com>
> >
> > ---
> >  drivers/staging/cx25821/cx25821-audio-upstream.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
> > index eb39d13..e7346ec 100644
> > --- a/drivers/staging/cx25821/cx25821-audio-upstream.c
> > +++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
> > @@ -762,9 +762,9 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
> >                       str_length + 1);
> 
> 
> I haven't tried checkpatch.pl over that file, but in the CodingStyle
> document you can read this:
> 
> Do not unnecessarily use braces where a single statement will do.
> 
> if (condition)
>         action();
> 
> This does not apply if one branch of a conditional statement is a single
> statement. Use braces in both branches.
> 
> if (condition) {
>         do_this();
>         do_that();
> } else {
>         otherwise();
> }
> 
> Which one is the correct style? I ask these because I have seen this
> in other parts of the kernel. So maybe I can help to homogenize this.
> 
> >                /* Default if filename is empty string */
> > -               if (strcmp(dev->input_audiofilename, "") == 0) {
> > +               if (strcmp(dev->input_audiofilename, "") == 0)
> >                        dev->_audiofilename = "/root/audioGOOD.wav";
> > -               }
> I believe only this one has to go.
> > +
> >        } else {
> So the first brace closes the brace of the if line.
> >                str_length = strlen(_defaultAudioName);
> >                dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
> 
> Thanks,
> Aldo Brett

Thats good to know thanks for pointing that out, I have picked up a few
discrepancies with interpretation and checkpatch.pl.
Am noting it and trying to patch checkpatch.pl as I continue :).

I think checkpatch.pl points this out as the opposite to interpretation
thou otherwise I would not have patched it I guess.

Current TODO on checkpatch:

1. type i = 0 ; /* space before ; is not picked up by checkpatch.
2. What you mentioned is interpreted different by checkpatch.pl 

Regards,

Joe


