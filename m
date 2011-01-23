Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab1AWAQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 19:16:54 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38982 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab1AWAQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 19:16:53 -0500
Message-ID: <4D3B7361.3030800@metafoo.de>
Date: Sun, 23 Jan 2011 01:16:33 +0100
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

On 01/23/2011 01:01 AM, Mark Brown wrote:
> On Sun, Jan 23, 2011 at 12:58:02AM +0100, Lars-Peter Clausen wrote:
>
>> I just went through the whole list and the wm8994 codec is a platform driver as well.
>> And on the jive board the wm8750 is connected through SPI.
>
> Yeah, Liam made up a lot of this stuff through guesswork but as you can
> see a mechanical run through fixing them won't work as not everything is
> I2C based in the first place.

On the other hand a mechanical run wont break anything that is not already broken,
but potentially fixes it.

I could resend the patch with those three cases which were definitely wrong in the
current patch fixed to use the correct SPI or platform id. Or I could just send the
fix for the neo1973 and neo1973_gta02 boards. Which one do you prefer?

- - Lars
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk07c2EACgkQBX4mSR26RiNwkgCcCwFvSv2k4pH+2KwHeP7zHB+3
aMsAn1PYvQnTXM36+DTASMgFXfcj9hRV
=OQXL
-----END PGP SIGNATURE-----
