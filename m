Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab1AVX7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 18:59:44 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38158 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab1AVX7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 18:59:43 -0500
Message-ID: <4D3B6F5A.2020309@metafoo.de>
Date: Sun, 23 Jan 2011 00:59:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, "for 2.6.37" <stable@kernel.org>
Subject: Re: [PATCH] ASoC: Fix codec device id format used by some dai_links
References: <1295735888-25527-1-git-send-email-lars@metafoo.de> <20110122233309.GA22799@opensource.wolfsonmicro.com>
In-Reply-To: <20110122233309.GA22799@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi

On 01/23/2011 12:33 AM, Mark Brown wrote:
> > On Sat, Jan 22, 2011 at 11:38:07PM +0100, Lars-Peter Clausen wrote:
> >
>> >>  sound/soc/imx/wm1133-ev1.c                     |    2 +-
Ok. I simply assumed that all of them were I2C devices since platform and SPI devices
use a completely different naming scheme.

I just went through the whole list and the wm8994 codec is a platform driver as well.
And on the jive board the wm8750 is connected through SPI.

> >
> > This at least is definitely wrong, the WM835x CODEC here is registered
> > as a platform device.  Please also check current kernels, a bunch of
> > these are already fixed.
The patch is based on your for-next branch.

- - Lars
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk07b1oACgkQBX4mSR26RiN3rQCeKvFG0eyVdxPh68vy3pasiKcv
iUUAn3lSz8cvKA95QI4Y9iRnyVk/bbWg
=0HnX
-----END PGP SIGNATURE-----
