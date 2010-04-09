Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0DIP4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:56:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41414 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab0DIP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=amB0OPh56pcwEPsLJNXPkgpH5gD4ijA4BNuD7MQrIHqwN+mzcdJIYLZ/bnjLU0dPsz
         l95UsK80aJpP7UVNkA2+7OtdvsgBzcZ0SAW60Wzo6ZJMu+apHWBGpNxZdbD81qdRmYD9
         Aw9ZA20G3F82InpjH1LzFchaEup2HJe5692ro=
Message-ID: <4bbf4e14.a215f10a.4c5c.41c9@mx.google.com>
Date: Fri, 09 Apr 2010 08:56:04 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
To: Andreas Mohr <andi@lisas.de>, Bill Davidsen <davidsen@tmr.com>
Cc: Andreas Mohr <andi@lisas.de>, Jens Axboe <axboe@kernel.dk>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100408203526.GA15426@rhlx01.hs-esslingen.de>
References: <20100404221349.GA18036@rhlx01.hs-esslingen.de>
	<4BBE38B9.6020507@tmr.com>
	<20100408203526.GA15426@rhlx01.hs-esslingen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Apr 2010 22:35:26 +0200, Andreas Mohr <andi@lisas.de> wrote:
> On Thu, Apr 08, 2010 at 04:12:41PM -0400, Bill Davidsen wrote:
> > Andreas Mohr wrote:
> >> Clearly there's a very, very important limiter somewhere in bio layer
> >> missing or broken, a 300M dd /dev/zero should never manage to put
> >> such an onerous penalty on a system, IMHO.
> >>
> > You are using a USB 1.1 connection, about the same speed as a floppy. If 
> 
> Ahahahaaa. A rather distant approximation given a speed of 20kB/s vs. 987kB/s ;)
> (but I get the point you're making here)
> 
> I'm not at all convinced that USB2.0 would fare any better here, though:
> after all we are buffering the file that is written to the device
> - after the fact!
> (plus there are many existing complaints of people that copying of large files
> manages to break entire machines, and I doubt many of those were using
> USB1.1)
> https://bugzilla.kernel.org/show_bug.cgi?id=13347
> https://bugzilla.kernel.org/show_bug.cgi?id=7372
> And many other reports.

Indeed. I have found this to be a persistent problem and I really wish there
were more interest in debugging this. I have tried bringing the community's
resources to bear on this issue several[1] times, and each time we fail to
get enough of the right eyes looking at it or developer interest simply vanishes.

I've started putting together a list[2] of pertinent threads/patches/bugs/data
in hopes that this will lower the energy barrier of getting up to speed on
this issue. Hopefully this will help.

Cheers,

- Ben


[1] https://bugzilla.kernel.org/show_bug.cgi?id=12309
[2] http://goldnerlab.physics.umass.edu/wiki/BenGamari/IoWaitLatency

