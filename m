Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab0H2MfF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 08:35:05 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57949 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0H2MfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 08:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tLX71b+mdEVvjEXVkAx+lm8JgI7P0BUoTiTkLvKG8f3nScfcxYO69tJ99A0gSpHtUv
         RnZf1lu2kZ7ihh2OTyOw91WUwUX3Y+cBy5DOyBxmUJ1tuKj82vyCqw0IB1uHfw1iK4Em
         iwTTOP587OG+G+V0ahD4niP2k+DrNmPfrunMw=
MIME-Version: 1.0
In-Reply-To: <20100828161858.GI1473@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<20100823174852.GB26928@pengutronix.de>
	<AANLkTimmEKfErV17RWNBO-pVCfFtFw=yJL2v92UBN0=2@mail.gmail.com>
	<201008281727.10913.marek.vasut@gmail.com>
	<20100828161858.GI1473@pengutronix.de>
Date: Sun, 29 Aug 2010 14:35:01 +0200
Message-ID: <AANLkTimhFAhR3sSJWo3b8_rMk5GCQfOwG0T36uEs=DjA@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/28 Sascha Hauer <s.hauer@pengutronix.de>:

> Peripherals integrated into a SoC like the SDMA engine here are
> normally accessible in native endianess and thus need the __raw_*
> functions.

So the SDMA actually switch and twist around the endianness of
its registers if it's synthesized into a bigendian version of the system?

Or hardware-dynamically even depending on the setting of the
endianness bit in the ARM core?

How can that possibly even work...

But I'm still impressed by the statemachines some silicon
engineers come up with so wouldn't surprise me. X-)
I understand the code now atleast. Our hardware is always
synthesized LE so we so handily use [read|write][b|w|l]
everywhere, luckily.

Yours,
Linus Walleij
