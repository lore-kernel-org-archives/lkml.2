Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1JJM1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:27:39 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45382 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1JJM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:27:38 -0400
MIME-Version: 1.0
In-Reply-To: <20111010123018.GD24198@S2100-06.ap.freescale.net>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
	<20111009093651.GC24198@S2100-06.ap.freescale.net>
	<CACRpkdbdz0FE57TdVryKD+X2=1sf-M9NgiZzm+Sm+WYhU6n_bQ@mail.gmail.com>
	<20111010123018.GD24198@S2100-06.ap.freescale.net>
Date: Mon, 10 Oct 2011 14:27:37 +0200
Message-ID: <CACRpkdbPYxoKHhPRTBXGyfcepRUpUhO0CFR_9ULvfFLU72OJpw@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 2:30 PM, Shawn Guo <shawn.guo@freescale.com> wrote:

>> +The example 8x8 PGA package above will have pin numbers 0 thru 63 assigned to
>> +its physical pins. It will name the pins { A1, A2, A3 ... H6, H7, H8 } using
>> +pinctrl_register_pins_[sparse|dense]() and a suitable data set as shown
>
> It should just be pinctrl_register_pins()?

Yep, fixed it.

>> +System pinmux hogging
>> +=====================
>> +
>> +A system pinmux map entry, i.e. a pinmux setting that does not have a device
>> +associated with it, can be hogged by the core when the pin controller is
>> +registered. This means that the core will attempt to call regulator_get() and
>> +regulator_enable() on it immediately after the pin control device has been
>> +registered.
>
> s/regulator_get/pinmux_get, and s/regulator_enable/pinmux_enable

Fixed this too, sorry for being so hung up on the regulator subsystem,
must be that I really like it...

Thanks,
Linus Walleij
