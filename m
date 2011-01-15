Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1AOA73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:59:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57535 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab1AOA7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:59:22 -0500
Date: Sat, 15 Jan 2011 00:58:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexey Charkov <alchark@gmail.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v12] ARM: Add basic architecture support for
	VIA/WonderMedia 85xx SoC's
Message-ID: <20110115005818.GV15996@n2100.arm.linux.org.uk>
References: <4D1011CF.9080800@bluewatersys.com> <AANLkTi=7O-HwQRcybnLSt+r+A64g=D7rZY7NbdEMFys3@mail.gmail.com> <4D110269.9030805@bluewatersys.com> <20101222211815.GA31054@alchark-u3s> <4D12730B.2030909@bluewatersys.com> <20101222222501.GA32693@alchark-u3s> <4D1282DA.4020804@bluewatersys.com> <20101222233821.GA20893@alchark-u3s> <AANLkTik1tcL_ABdnq5r=MCxmLJtdP0nhOzA8irP1n0CC@mail.gmail.com> <AANLkTinb3A5CJ6r4Y0D0kMwJn8ZEyf_0mb4uW99mmUZ9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinb3A5CJ6r4Y0D0kMwJn8ZEyf_0mb4uW99mmUZ9@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 03:53:56AM +0300, Alexey Charkov wrote:
> 2010/12/28 Alexey Charkov <alchark@gmail.com>:
> > 2010/12/23 Alexey Charkov <alchark@gmail.com>:
> >> This adds support for the family of Systems-on-Chip produced initially
> >> by VIA and now its subsidiary WonderMedia that have recently become
> >> widespread in lower-end Chinese ARM-based tablets and netbooks.
> >>
> >> Support is included for both VT8500 and WM8505, selectable by a
> >> configuration switch at kernel build time.
> >>
> >> Included are basic machine initialization files, register and
> >> interrupt definitions, support for the on-chip interrupt controller,
> >> high-precision OS timer, GPIO lines, necessary macros for early debug,
> >> pulse-width-modulated outputs control, as well as platform device
> >> configurations for the specific drivers implemented elsewhere.
> >>
> >> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> >
> > Russell, will you take this for .38? Please note that the last
> > revision of this patch was also submitted to the ARM Linux patch
> > tracking system:
> >
> > http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6597/1
> >
> > Best regards,
> > Alexey
> >
> 
> Russell, I realize that there are quite a lot of other things to worry
> about currently in the ARM Linux world, but could you please still
> consider merging this patch before .38 window closes?

It got lost in the patch system in the middle of the SPEAR deluge -
and after that deluge I did say on list that it would result in things
being missed.  I've basically been ignoring everything in there since
beyond the top few newest entries.

In any case, I believe it's too late in this merge window with only
four days left to start merging large amounts of code.  I'd get
moaned at by Linus.  Sorry.
