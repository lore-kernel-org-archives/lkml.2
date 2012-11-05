Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2KENqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:46:13 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:55903 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab2KENqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:46:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
Date: Mon, 05 Nov 2012 14:50:20 +0100
Message-ID: <2396674.M1Yl70Z09T@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CACRpkdbRWPYHBwLVTm-TDRVyp9Kmoaxw0uZg0schn7i0koDKJw@mail.gmail.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <4684026.MA6h34pt1X@vostro.rjw.lan> <CACRpkdbRWPYHBwLVTm-TDRVyp9Kmoaxw0uZg0schn7i0koDKJw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 05, 2012 02:28:45 PM Linus Walleij wrote:
> On Mon, Nov 5, 2012 at 2:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, November 05, 2012 02:11:03 PM Linus Walleij wrote:
> >> Do you think they will change their mind and give me green light if
> >> I tell them I just need to do it right now? ;-)
> >
> > Well, it's just a matter of fairness to me, actually.
> >
> > If you allowed somebody to do something in the past, it's simply unfair
> > to forbid someone else to do a similar thing later, isn't it?
> 
> So if some subsystem has previously merged clk_get() for
> the silicon clock pertaining to a driver the maintainer should
> be fair to the pinctrl people and merge pinctrl_get() as well.

Well, let's just say if I were the maintainer of the subsystem in
question, I would propose a deal like this: I'm going to merge your
patches now, provided that you'll work on the centralized solution
going forward.  And it's quite easy to call them on the promise like
this in the future, when they ask you to merge something again.

> Well, they don't. But it wasn't any of your subsystems so
> I don't blame you.
> 
> I have been stand-in-maintaining the GPIO subsystem
> for the last two merge windows and I am worrying about the
> long term viability of the subsystem if we keep doing this
> without facing the real problem of the global GPIO
> numberspace.
> 
> But since Grant merged the gpiolib-of.c thing and is still the
> main maintainer I can atleast chicken out by referring to him
> this time ... hit me back if he doesn't respond and I will
> have to refactor the world or something.

No need to be grumpy. :-)

I forgot to mention that we want to hook up _existing_ drivers to those things,
and they already use the global GPIO numbers, don't they?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
