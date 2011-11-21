Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1KUMMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:12:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60714 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1KUMMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:12:54 -0500
MIME-Version: 1.0
In-Reply-To: <4EC52842.8020906@compulab.co.il>
References: <1321537582-8624-1-git-send-email-linus.walleij@stericsson.com>
	<4EC52842.8020906@compulab.co.il>
Date: Mon, 21 Nov 2011 13:12:54 +0100
Message-ID: <CACRpkdZ0rgNzd1SKfE47J0yR51g0hd+mwuA7Ku6UD_wa3Mzi1g@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: indicate GPIO direction on single GPIO request
From: Linus Walleij <linus.walleij@linaro.org>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 4:29 PM, Igor Grinberg <grinberg@compulab.co.il> wrote:

> You haven't responded to my request for the previous version...

Sorry, probably missed it :-(

>>  static int pin_request(struct pinctrl_dev *pctldev,
>>                      int pin, const char *function,
>> -                    struct pinctrl_gpio_range *gpio_range)
>> +                    struct pinctrl_gpio_range *gpio_range,
>> +                    bool gpio_direction)
>
> can this (and other instances) be:
> s/gpio_direction/gpio_direction_out/

Yes I realized this morning that this is a better solution.
Will post some v3 ASAP.

Thanks,
Linus Walleij
