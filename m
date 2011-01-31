Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1AaGxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 01:53:41 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47874 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1AaGxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 01:53:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mWc0RtCU5D4XDsG55N1IAzx6wX7uogPiRBEfvTXUfoEVtOmvc/qA+eWFljuFWoGdQX
         REen3sM7UaHwre2ec6R+Xtih8YcTK7j3EWjrSBmO9Arz6f/GTdM+OQn4wixnqaUk4vXJ
         wozOO/LTBB4y7viVFGn2HnBNaFL+RDSUnhP28=
MIME-Version: 1.0
In-Reply-To: <20110130221434.GB28220@pengutronix.de>
References: <AANLkTinuphNyLoFz1TLxFJ6=g+GMph6njGhs2FBB6Evj@mail.gmail.com>
	<20110130221434.GB28220@pengutronix.de>
Date: Mon, 31 Jan 2011 07:53:39 +0100
Message-ID: <AANLkTikFU1gcC-wUbujh3hkxyRQgQFc8Zb1w-Tx+7zYb@mail.gmail.com>
Subject: Re: [leds-pca9532] Add gpio capability v2
From: Joachim Eastwood <manabian@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: rpurdie@rpsys.net, riku.voipio@iki.fi, linux-kernel@vger.kernel.org,
        joachim.eastwood@jotron.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 11:14 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Sun, Jan 30, 2011 at 09:20:13PM +0100, Joachim Eastwood wrote:
>> Hello,
>>
>> This is v2 of the patch to add gpio capability to the leds-pca9532
>> driver. Please read the first mail in this thread for more
>> information.
>>
>> Changes in v2:
>> * Add Kconfig magic. gpio capability is now optional
>> * Addressed review from Wolfram Sang
>>
>> Wolfram: If this looks okey can I add your Reviewed-by tag?
>
> The patch seems line-wrapped. Is checkpatch happy (enough), too?
> Other than that looks good to me:

checkpatch reports a couple of line over 80 chars but that is it.

> Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

Thanks for your time.

regards
Joachim Eastwood

> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iEYEARECAAYFAk1F4soACgkQD27XaX1/VRvrLQCgpgfO88OCvM05+QIxaSV2LDRi
> L/YAoKODhHKkogJdq3W1s1x0IuhvfceD
> =+iVA
> -----END PGP SIGNATURE-----
>
>
