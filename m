Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2IYJlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:41:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33209 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab2IYJlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:41:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120925090151.GB1247@liondog.tnic>
References: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
	<CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
	<20120925090151.GB1247@liondog.tnic>
Date: Tue, 25 Sep 2012 12:41:11 +0300
X-Google-Sender-Auth: 4dgTL0SAUIzSLhSRaLbuL-NAfYY
Message-ID: <CABGkUugOvWCSfXvLW33jmntGYAAiPP9fStXbdRAozx3bEoKBOA@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Added support for Acer Aspire 5755G fan control.
From: Tero Keski-Valkama <tero.keski-valkama@neter.fi>
To: Borislav Petkov <bp@alien8.de>,
        Tero Keski-Valkama <tero.keski-valkama@neter.fi>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/25 Borislav Petkov <bp@alien8.de>:
> On Tue, Sep 25, 2012 at 10:34:13AM +0300, Tero Keski-Valkama wrote:
>
> But before we go with this any further: you mentioned some issues still
> with acerhdf - you don't want to turn off your fan but to turn it to
> full?
>
> I think in this case, you want to simply not load the driver and use the
> BIOS settings, no?
>
> --
> Regards/Gruss,
>     Boris.

Technically I think my original issue is about thermal zones, and BIOS
control doesn't solve it as is. However, the patch should be valid,
even if it doesn't solve my original issue.

The thing is that passive cooling thermal zones throttle all the cores
to stone age, to 800 MHz, before the fan even really starts powering
up from the low default level. So, my original problem would be solved
by:
a) Direct control of the fan, to be able to put it on full for example
through userspace control,
b) Changing the active cooling thermal zones, so that the fan speeds
up earlier, or
c) Changing the passive cooling (CPU throttling) thermal zones, so
that it doesn't prevent fan from speeding up in the first place.

At the moment, I don't see any way to change the thermal zones through
existing interfaces for this laptop, and I don't see any potential
thermal zone controls, or manual fan control option in the Embedded
Controller registry.

-- 
Kind Regards / Ystävällisin terveisin,

Tero Keski-Valkama, MSc(Tech)

+358 (0)46 876 0485

tero.keski-valkama@neter.fi
http://www.neter.fi
