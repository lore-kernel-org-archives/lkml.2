Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab2BBThr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:37:47 -0500
Received: from antcom.de ([188.40.178.216]:33196 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137Ab2BBThp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:37:45 -0500
Message-ID: <4F2AE606.7090903@antcom.de>
Date: Thu, 02 Feb 2012 20:37:42 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: LPC32xx: Support for OHCI HCD
References: <1328103028-20547-1-git-send-email-stigge@antcom.de> <20120202164114.GB3219@pengutronix.de>
In-Reply-To: <20120202164114.GB3219@pengutronix.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/02/2012 05:41 PM, Wolfram Sang wrote:
> Okay, I asked for a patch to test USB, so thanks. It did not work 
> for me, sadly, so there seems to be more work needed in that area.

Of course, we need to first sort things out. :-)

Already now, when you apply all my patches on top of each other, USB
(and ethernet) works fine for me.

Of course, the just re-posted base series ("v3") has priority, but if
you are curious, you can have a look at the patches at
http://antcom.de/lpc32xx/ and apply them on top of current mainline
(3.3-rc2). You need to manually enable OHCI and the LPC-ETH drivers,
based on our new defconfig, of course. If it still doesn't work,
please tell me at which point it doesn't compile or boot.

I just re-tested this with my PHYTEC3250 board, using NFS root and
mounting USB mass storage.

> also misses important mailing lists (usb).

I posted the drivers for ethernet, usb and iio to the respective
maintainers and mailing lists, separately.

> May I ask if you read Documentation/development-process and/or 
> Documentation/SubmittingPatches? If not, please do so.

Good. Thanks for the hint. :-)

We can do one step after another.

Thanks for your involvement here!

Roland
