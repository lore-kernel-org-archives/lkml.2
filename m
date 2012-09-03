Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2ICLwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:52:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60120 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab2ICLwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:52:00 -0400
MIME-Version: 1.0
In-Reply-To: <F45880696056844FA6A73F415B568C695B0EA11A90@EXDCVYMBSTM006.EQ1STM.local>
References: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
	<CACRpkdakZMWnk1zzFqa8SXLsDn9EaSxzKnH_yXoCaxCY5saVJQ@mail.gmail.com>
	<F45880696056844FA6A73F415B568C695B0EA11A90@EXDCVYMBSTM006.EQ1STM.local>
Date: Mon, 3 Sep 2012 13:51:58 +0200
Message-ID: <CACRpkdZGu+GT+V7i+h3YrQDN930MYYprLS1kmgM1+rOaUaebdA@mail.gmail.com>
Subject: Re: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Arun MURTHY <arun.murthy@stericsson.com>
Cc: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 1:28 PM, Arun MURTHY <arun.murthy@stericsson.com> wrote:
>> On Sun, Sep 2, 2012 at 12:30 PM, Thierry Reding <thierry.reding@avionic-
>> design.de> wrote:
>>
>> > This commit moves the driver to drivers/pwm and converts it to the new
>> > PWM framework.
>> >
>> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>> > ---
>> > Note: I'll take this through the PWM tree, but I'd like to have it
>> > acknowledged by a few people who know the hardware and can actually
>> > test whether this still works.
>>
>> Pls include Arun on these patches, he'll know best if it'll work or not.
>>
>> I have one generic question: will this alter the layout of sysfs so we need to
>> change userspace? I had such issues before when moving drivers to new
>> busses...
>>
>
> Since this pwm framework is still a set of exported functions in a header file,
> the file architecture doesn't really matter.
> Using this driver, either leds-pwm and backlight-pwm is used to register and
> this is where actual registration happens(sysfs entry is created).

OK sounds good to me,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
