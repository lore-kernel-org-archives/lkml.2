Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab0GLRlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:41:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152Ab0GLRlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:41:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100712173228.GC9897@n2100.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603181010.GA25779@flint.arm.linux.org.uk>
	<1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
	<alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
	<20100614083214.GA2104@pengutronix.de>
	<20100630104043.GG11746@pengutronix.de>
	<20100712155518.GA24144@pengutronix.de>
	<AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com>
	<20100712173228.GC9897@n2100.arm.linux.org.uk>
Date: Mon, 12 Jul 2010 10:40:36 -0700
Message-ID: <AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 10:32 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> When you brought up the problem you seemed absolutely convinced
> that nothing except your solution was going to be acceptable.

That's not true. What's true is that you didn't seem to _understand_
my solution, so I tried to push the understanding of it.

There are always other solutions. I seriously doubt that Uwe's is a
maintainable one. That said, even a one-time "reduce the size of that
stinking pile of sh*t" is probably better than nothing.

I hope you at least do agree that the current situation is a steaming
pile of sh*t. And yes, I _will_ remove the crap, both from POWER and
ARM, unless I see some serious tries at fixing it.

               Linus
