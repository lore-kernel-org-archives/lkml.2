Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2KHMwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:52:30 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33099 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab2KHMwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:52:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpon2OBMgNjc5RRGibEUqN_yPGPdXX5RBFP-bQLmyeF4zuw@mail.gmail.com>
References: <1352214994-30232-1-git-send-email-linus.walleij@stericsson.com>
	<CAKohpon2OBMgNjc5RRGibEUqN_yPGPdXX5RBFP-bQLmyeF4zuw@mail.gmail.com>
Date: Thu, 8 Nov 2012 13:52:16 +0100
Message-ID: <CACRpkda0mZ8=ZhR7XkM8b09tWQeK8N3gKTv_FTNTnp_=ennqeA@mail.gmail.com>
Subject: Re: [PATCH 1/5] gpiolib: fix up function prototypes etc
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 6:09 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 6 November 2012 20:46, Linus Walleij <linus.walleij@stericsson.com>

>> -void gpiochip_add_pin_range(struct gpio_chip *chip, const char
>> *pinctl_name,
>> -               unsigned int pin_base, unsigned int npins);
>> -void gpiochip_remove_pin_ranges(struct gpio_chip *chip);
>> -#endif
>> +#ifdef CONFIG_PINCTRL
>
> Shouldn't this be ifndef??

Probably, fixed up in later patches...

Yours,
Linus Walleij
