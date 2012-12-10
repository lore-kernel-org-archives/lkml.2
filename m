Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2LJVsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:48:08 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37359 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab2LJVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:48:05 -0500
MIME-Version: 1.0
In-Reply-To: <50C5EC4D.4070102@linux.intel.com>
References: <1354888899-21907-1-git-send-email-mathias.nyman@linux.intel.com>
	<1354888899-21907-2-git-send-email-mathias.nyman@linux.intel.com>
	<CACRpkdYG641KYR05jtu3OS7BDGcFpJ-pzu+gTM+RHJnMqytfEQ@mail.gmail.com>
	<50C5EC4D.4070102@linux.intel.com>
Date: Mon, 10 Dec 2012 22:48:03 +0100
Message-ID: <CACRpkdaMuBrWwd5Z_KUNbt8KCFGiNxVvX58T2y9nX-EZS3_fjg@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: add Lynxpoint chipset gpio driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: grant.likely@secretlab.ca, mika.westerberg@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 3:06 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

>>> +static void lp_irq_enable(struct irq_data *d)
>>> +{
>>> +       struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
>>> +       u32 gpio = irqd_to_hwirq(d);
>>
>>
>> That variable is confusingly named. It's not a global gpio number,
>> it's a local offset, so please rename it "offset".
>
> sure, (is "pin" ok?  "offset" is already used in may places)

pin will confuse things to the pinctrl subsystem ... offset is really nice.
But no super-big deal.

Yours,
Linus Walleij
