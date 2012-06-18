Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab2FRM4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:56:54 -0400
Received: from antcom.de ([188.40.178.216]:39442 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab2FRM4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:56:51 -0400
Message-ID: <4FDF2590.4010901@antcom.de>
Date: Mon, 18 Jun 2012 14:56:48 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi: spi-pl022: Adjust probe() to of_get_named_gpio()
 returning -EPROBE_DEFER
References: <1340011219-31657-1-git-send-email-stigge@antcom.de> <CACRpkdYTE0imxEAdq0=wJO49iBAj=8xGjn_PevFm1Bsr3MvUQg@mail.gmail.com> <CAAAP30GAwQZtjAjtX=Q8K0Szo83QwqCZNtr09GxrgcvcR-CKeA@mail.gmail.com>
In-Reply-To: <CAAAP30GAwQZtjAjtX=Q8K0Szo83QwqCZNtr09GxrgcvcR-CKeA@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 01:51 PM, Alexandre Pereira da Silva wrote:
> On Mon, Jun 18, 2012 at 8:47 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Mon, Jun 18, 2012 at 11:20 AM, Roland Stigge <stigge@antcom.de> wrote:
>>
>>> The patch to gpiolib-of.c providing -EPROBE_DEFER as a hint to defer
>>> of_get_named_gpio*() to a later probe() breaks spi-pl022.c.
>>>
>>> This patch adjusts to this change, using -EPROBE_DEFER as indication to defer.
>>>
>>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> 
>>> Should this patch be joined with gpiolib-of's patch to of_get_named_gpio()? Or
>>> should they just be issued as a series?
>>
>> If it's not bisectable unless you change this in the same patch then join
>> them. Else I'd put them in a series and try to figure out a good tree for
>> merging them.
> 
> Ok, so lets keep the original patch as is for now.

When Linus Acked both patches for *spi-pl022* (dt + gpio/defer fix), and
they are not yet applied, please merge them. No need to introduce
intermediate breakage.

You can keep my Signed or Acked line for exactly this.

We'll keep the patch for *gpiolib-of* separate, of course.

Thanks,

Roland
