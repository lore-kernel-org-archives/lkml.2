Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0GLQwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:52:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188Ab0GLQwg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:52:36 -0400
MIME-Version: 1.0
In-Reply-To: <20100712155518.GA24144@pengutronix.de>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603181010.GA25779@flint.arm.linux.org.uk>
	<1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
	<alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
	<20100614083214.GA2104@pengutronix.de>
	<20100630104043.GG11746@pengutronix.de>
	<20100712155518.GA24144@pengutronix.de>
Date: Mon, 12 Jul 2010 09:51:47 -0700
Message-ID: <AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/12 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>
> As you havn't replied up to now I wonder if that just means that you
> still plan to remove all defconfig files or if you are just busy doing
> other things.

The reason I haven't replied is that

 (a) I don't think this really "solves" the issue, in that the
resulting files still aren't human-readable, and as such I suspect it
doesn't solve the problem in the long run: people will continue to
just run "make config" and then copy the resulting .config file as a
defconfig file.

and

 (b) even if ARM were to go this way, and run the scripts to minimize
the defconfig files, that's not something _I_ would do. If I get tired
of seeing the insane pull requests where 90% of the crap is just
defconfig noise, then _my_ solution will be to remove the crap because
I simply am never going to be the person who maintains those defconfig
files.

See? Especially the "(b)" part is relevant - I am simply not going to
be the person who tries to clean up after other people sh*tting all
over their trees with defconfig files.  If I do something, it will be
total surgery, ie "keep your damn broken defconfig files somewhere
else than in my tree - I'm tired of your stupidities". It will not be
"I'll be your mother and clean up your room every day after you made a
mess".

So if the ARM people decide that your script is a good way to clean up
the mess, I might be happy with that. But that would require that they
NEVER EVER try to push me a update that contains an un-cleaned-up
defconfig file. If they do, and the defconfig files end up showing up
big in git history, then the approach has failed.

See? The reason I'm not replying to your approach is that it's simply
not for me to do so (and no, I don't think it's maintainable, but I
haven't tried it, so..)

                            Linus
