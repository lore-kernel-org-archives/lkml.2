Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423024Ab2KNOhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:37:14 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37462 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422981Ab2KNOhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:37:12 -0500
MIME-Version: 1.0
In-Reply-To: <20121114131806.GA17338@gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
	<1351089926-32161-3-git-send-email-lee.jones@linaro.org>
	<CACRpkda2NQok7kzh0pFmZPYd4nky1kUw=67DZAYAJAXGuc1yzQ@mail.gmail.com>
	<CACRpkdbNWE6hOdVFPxHv7MVHkZUBW3LC035CxJkZVmr8j05Kqw@mail.gmail.com>
	<20121025155143.GK4008@gmail.com>
	<CACRpkdbkcgE-qwuGgOvK9jGTj-0qy3eTFLsN3LYe1G17LmHk9g@mail.gmail.com>
	<20121114131806.GA17338@gmail.com>
Date: Wed, 14 Nov 2012 15:37:11 +0100
Message-ID: <CACRpkdZXvU0nWrV8oi9JvoOhi9CEbA7PWf_D6Z2MPz1J1zeWXw@mail.gmail.com>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 2:18 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 25 Oct 2012, Linus Walleij wrote:
>
>> On Thu, Oct 25, 2012 at 5:51 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> > On Thu, 25 Oct 2012, Linus Walleij wrote:
>>
>> >> Probably some driver is needing a clk_get() or a clk_get_sys() is
>> >> needs to be added somewhere to bring up some vital cluster,
>> >> or there may be some out-of-tree driver needed to bring up the
>> >> cluster properly I have no clue... Maybe some cluster just
>> >> cannot be declocked like that.
>> >
>> > I leave work in 10 mins and won't be coding again for ~2.5 weeks.
>> > So if this is something you could squeeze in and fix-up, I'd be
>> > very grateful.
>>
>> I'll try. It doesn't look right that a clk_prepare() in the pinctrl
>> driver is saving the day for somebody else...
>
> Hi Linus,
>
> Did you apply this in the end?

No I can't. If I fix the bug in the patch (removing the surplus
clk_prepare() in the probe function) the thing regresses the
entire kernel, so I have no patch which actually is working.

It needs to be root-caused and fixed properly...

Yours,
Linus Walleij
