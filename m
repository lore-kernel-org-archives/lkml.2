Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0KIVxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:53:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36842 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0KIVxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:53:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HtDf9zvNcHugZNv6UZXw0w/LI5HIoab1x7CJ9Xp3oZc9uQULeE/ZH0C2M8/gabKLnv
         iN/PlNjZo6jjNbog8jpv9aRJMpENefGYPf6qPZIbCee4pgts1SOop0PsxfipouS2YE+7
         sqAXYB9/8lB0+MiINQqU3LNqTAHUY0v8lm3WY=
MIME-Version: 1.0
In-Reply-To: <20101109175828.GA27627@kroah.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
	<AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
	<201011091729.17679.arnd@arndb.de>
	<20101109165509.GA9698@kroah.com>
	<AANLkTinFW431t9XFqHc=wZAws9gjT0ikrc03J83kH7iF@mail.gmail.com>
	<20101109172511.GA10958@kroah.com>
	<AANLkTi=CKERMcSLXwQa7G55P69DO--UPN9HgOScHP_yO@mail.gmail.com>
	<20101109175828.GA27627@kroah.com>
Date: Tue, 9 Nov 2010 23:53:29 +0200
Message-ID: <AANLkTin0Lszi6MVo8GBWmpvMQRL3V+VGbtGdaMkBe5XO@mail.gmail.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 7:58 PM, Greg KH <greg@kroah.com> wrote:
> If it is easy to revert and push later, then the "revert just this
> piece" should be done now.
>
> Seriously, I'm getting very confused here, and am very annoyed by the
> whole thing.

With good reason.

> Here's what I don't like:
>  - the original driver didn't even seem to work properly

It _was_ working properly, when it was a separate branch, but the
merge to staging wasn't done correctly, so it has never worked there.

>  - people sent me patches they never tested and broke things even worse

Part of the blame goes to TI. Even if you have the hardware, it's not
straightforward to test this. I have struggled to improve the
situation on user-space with the gst-dsp and dsp-tools projects, which
btw have not received support from TI, but apparently they were not
used to test this (neither was the "official" solution from TI which
is much harder to set up).

>  - some people have no respect for the omap maintainers and what they
>    think about things, or even basic knowledge of the kernel
>    development cycle.

I don't think this is the case. The opinion of the OMAP maintainers is
valuable in order to cleanup the mess that is this driver. But _first_
it has to work. Most people are not developers, they just want to use
this driver.

>  - I do not have this hardware so I can't test anything.
>
> So, from now on, I'm not taking ANYONES patches for this driver unless
> it gets an ack from the driver maintainer, Omar Luna.
>
> Actually, no, I'm not going to take any patch unless it _comes from_
> Omar.  Omar, please work to queue up patches and test them, and then
> send them to me for merging.
>
> Any questions?

You mean after this pull, or should Omar re-send this pull request?

-- 
Felipe Contreras
