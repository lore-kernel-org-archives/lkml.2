Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0GBLyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:54:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45878 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0GBLx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EPj+/PlJ+zzsWuGHHvkeyxCjDvAbGS1PuYTVQkD6pQf/cHQ0js1ZICNw38c5gwQgP8
         3RDPg9IdxX0jEpfGLTyRQ0fvKyoSoxUr+5itzM2H8T8DuW8jVmUCqiNY4W3cBEsBPg43
         NEqoeEaOMNyZvdIkcmOc3INiz4e0Fk4fY0Xfo=
MIME-Version: 1.0
In-Reply-To: <20100702111029.GB6802@skynet.be>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	<20100702095815.GA6802@skynet.be>
	<AANLkTimNgjtvDYY42dm-6akRjQfkHayagQWwHSS3AQs7@mail.gmail.com>
	<20100702111029.GB6802@skynet.be>
Date: Fri, 2 Jul 2010 21:53:58 +1000
Message-ID: <AANLkTikomWNbwHT-kQOm8UsUS1xkMW69cZ-mC6d8Dj56@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Dave Airlie <airlied@gmail.com>
To: Luc Verhaegen <libv@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, but you still slammed, and this affected in first order mostly Qualcomm, instead
> of stating that you simply do not want to be involved.

I have no choice but to be involved, again you seem to misunderstand
what my position is.

>
>> They'll keep shipping closed stuff, just like they are now. Are you
>> going to reverse engineer the userspace drivers, so people who care
>> about open and free software platforms can use these drivers? (or have
>> you already signed NDAs saying you can't). Why should we maintain a
>> bunch of kernel code, when they are hiding away all the really useful
>> stuff that people could improve.
>
> Maintaining this exact code is not _your_ job, and you should've stated just that.

Maintaining kernel graphics drivers is my responsibility, a lot of
days i wish it wasn't, and I'm sure some day it won't be, but until
then I have to provide guidance on how things should work. Again you
should look at what being a kernel maintainer is.

>
> You will need to restate this every time anyway, unless you somehow manage to get your
> rather daunting and loud statement to be the first thing such corporations management
> people at linux.com, which is what people type in their browser first.

I'm sure I will, but now I can just point people at this rather public
statement as opposed to private emails.
>
> Heh, i could make a really nasty statement here, but i wont.

Please do, since you've proved you are clueless about this position entails.

> Hrm, i only see _very_ old docs getting updated, and none produced.
>
> I still have docs which are pretty ready to be shipped (from 2007), under uncertain
> legal status (the ati game was fun!), which were never made public. I am sure that
> bridgman, gave you these docs too, but under even more shady circumstances.

Shady circumstances? you might want to ask your lawyer before making
statements like that on a public mailing list.

>> The code doesn't exist, there is no userspace code to be the
>> documents, if you read what I said, documents would be a good start in
>> lieu of code, but code is perfectly fine.
>
>> Imagintaion technologies seriously? they've never ever taken one step
>> towards opening anything, I don't think this statement is suddenly
>> going to jumpstart them.
>
>> Maybe you should disclose what NDAs you currently are under and who
>> pays your bills, since you accuse me of Red Hat mind-control.
>
> Oh, i now work for basysKom, a contractor for, amongst others, nokia, which i'm sure
> you knew.

So you honestly think if I allow Nokia and/or Intel to push a poulsbo
driver into the kernel the magic fairies will come along and open the
userspace because they've seen the light?

What incentive does letting someone like Qualcomm etc put all their
kernel code upstream, and ignoring the userspace components do you
think it provides to open the userspace component, for once I'm
interested in your opinion since you seem to have the ARM players all
worked out. Previous experience with most companies has shown they'll
do as little as possible to ensure they can ship as many things as
possible, and this is fine, they need real incentives to follow the
open source rules.

>
>> I'm not sure how the ARM market would benefit from having no userspace
>> 3D drivers just like the x86 market, if you actually were normal you'd
>> realise the ARM people are trying to screw the market just like the
>> desktop people, to save themselves some money, but maybe working on
>> closed drivers has twisted you.
>
> Ah, so you did know.
>
> As a free software graphics driver developer there is little option left but to go
> straight to the ARM world, at least things have potential to move there still.

What potential? there are maybe 6 players on the ARM graphics scene

Imagination Technologies SGX, used in TI and poulsbo/mrst(x86) - no
hope of opening userspace
ARM Mali - not sure what is going on there, I;m going to go with no
hope but would be nice to be proved wrong
Qualcomm SnapDragon - imageon by another name, from what I can and
from talking to Jordan on irc, they don't seem to have much incentive
to bother working on an open userspace
Marvell - maybe OLPC can make them open a userspace for millions of
sales, it doesn't seem to have worked with VIA for 10s of thousands of
persumable sales
Samsung - also holding out hope for something maybe, they seemed to
have some interest once, but not sure what happening now.
Nvidia - well we know their position will never change.

So we should have six completely separate stacks shipping in the
kernel not using drm or kms, but all standalone, all with closed
userspace drivers, with no maintainer, thanks that is not a future I'm
interested in, and generally from experience in Linux it isn't
something we've had much luck with before, wireless, networking, sw
raid, etc all have this sort of vendor demands and it took independent
maintainer pushback to achieve some cooperation and get what we have
today.

Dave.
