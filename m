Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2K1S61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:58:27 -0500
Received: from relay.ams1.hosting.nl ([82.197.222.253]:53745 "EHLO
	relay.ams1.hosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab2K1S61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:58:27 -0500
X-Originating-IP: 127.0.0.1
Message-ID: <20121128195821.71024xoxi57896tp@62.129.139.42>
Date: Wed, 28 Nov 2012 19:58:21 +0100
From: "sander van ginkel" <sander@van-ginkel.eu>
To: "Tim Michals" <tcmichals@gmail.com>
Cc: "Wolfram Sang" <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] add hardware I2C support for ARM IMX23
References: <20121128152403.45224dvyaufb1j7n@62.129.139.42>
	<20121128150851.GA4659@pengutronix.de>
	<20121128171039.14705ltphptrp5kv@62.129.139.42>
	<20121128162452.GB4659@pengutronix.de> <50B63F81.4050008@van-ginkel.eu>
	<CANqk_c-UemJvfoFQMt-iNUU0YmiSt-fb-=Y9=eKwE=ka-ffw6A@mail.gmail.com>
In-Reply-To: <CANqk_c-UemJvfoFQMt-iNUU0YmiSt-fb-=Y9=eKwE=ka-ffw6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sander,
>
> Just tested with "i2cdetc -y -r 0" that crashes with  "BUG: soft
lockup -
>> CPU#0 stuck for 22s!"
>> according to the docs (IMX23RM.pdf) the interrupts for I2C are 26
and 27
>> that why I assigned these two in the dts.
>>
>
> In your dts, is it 26, 27? Order matters, it should be 27, 26.
Error ISR,
> DMA.
>

Hi Tim,

Thanks for your suggestion. I swapped the numbers and it solved the crash.
However I still have to debug some more because it gives now :
  mxs-i2c 80058000.i2c: Failed to get PIO reg. write descriptor.

Thanks,

Sander

