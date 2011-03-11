Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1CKWyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:54:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54337 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1CKWyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vEtcN/KLfoiAdyFfwmnsKsEB00tpJL85Lw1iC8at7Tf/u+MTuFVOR+B5x7oIbhOO33
         k7vHWsuy79MSQFZ37iEF/y3gnIOIh3rUcpikPLIg2ScEhm8/7ZmJKrzAywPVClqEeO33
         ZUxGU53073koxsLqLBogfxU0ZIoAojemRSP0M=
Date: Fri, 11 Mar 2011 22:12:25 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Greg Brigley <gbrigley@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to use gma500 framebuffer driver?
Message-ID: <20110311211225.GA5492@Boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <AANLkTikwjHbPWp5xwZFLStEupck46mFw5dqEUcQOXiD6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikwjHbPWp5xwZFLStEupck46mFw5dqEUcQOXiD6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 01:55:39PM -0500, Greg Brigley wrote:
> Hi all,
> 
> I'm trying to test the poulsbo/gma500 driver recently added to
> drivers/staging in linux-next, and having trouble.  I'm hoping someone
> can help me get going (or let me know if I should be asking somewhere
> other than the main kernel list.)
> 
> I did a git clone of linux-next. I got errors trying to build the
> gma500 driver on the head, so I did a checkout to
> 0e83f46d3869a5255a04b875bb885bd141a609ef, from Feb 26 - the last
> commit on drivers/staging/gma500, and now I can build successfully,
> but have not succeeded in producing video output.
> 

What is your model/brand?

> I guess I'll start by saying what I'm trying to do, to make sure I'm
> not misguided in trying this in the first place.  I want to run Xfbdev
> and drive both an LVDS and HDMI display at the same time (mirrored).
> I don't need 2d or 3d acceleration.  I don't see an indication that
> anyone else has tried mirrored displays with this driver, and I don't
> mind being the first, but should it work in theory?  If it's not
> supported, would it be difficult to add?
> 

Mirroring doesnt work from what Ive tested.


> My hardware is an embedded system, containing one of these:
> http://www.radisys.com/Products/COM-Express/COM-Express-Modules/Procelerant-CEZ5XT.html.
>  I've successfully driven the two displays using Ubuntu 10.10 with
> added poulsbo drivers and other pieces, so I know the hardware is good
> and can work this way if the driver supports it.
> 
> So here are my questions for those who have used the staging driver:
> * Should I be compiling it as a module, or as part of the kernel?

I prefer builtin, but doesnt matter really.

> * If I'm compiling it as part of the kernel, what kernel parameters do
> I use to activate it?

None

> I tried to guess based on past experience with
> non-DRM framebuffer drivers, but I get the impression that DRM
> framebuffers are different, and I don't really have any experience
> there.
> * If I'm compiling it as a module, is there some sort of incantation
> to make the framebuffer device show up when I insert the module?
> Currently, when I insmod psb_gfx.ko, nothing appears in /proc/fb, or
> in /dev.  I'm using udev.  If I do "mknod /dev/fb0 c 29 0", then both
> fbset and Xfbdev give me "no such device" errors.
> 

So something not working right.

> I'll stop there for now, in case I'm entirely on the wrong track, but
> I'm happy to provide more detail if anyone is able to help.  I'm very
> motivated to get this working, and if there's anything I can do to
> help with development or testing of the driver going forward, I'd be
> happy to do so.
> 

Im running linux-next since the patches first arrived, works fine so far.
Got a sony vaio P. 

> Thanks,
> Greg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
