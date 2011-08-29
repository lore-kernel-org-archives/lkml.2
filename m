Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1H2SLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:11:24 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33620 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1H2SLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:11:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110829151333.GA17887@n2100.arm.linux.org.uk>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
 <CACRpkda6-8dxSbF12N-Q32cOpogu-ZZmTApnvNBa03iOcEeqaQ@mail.gmail.com>
 <CAK5ve-JM=01vTqSi59R6ASyGU_2fVXzKtjNh42LKeF2HF3NzSA@mail.gmail.com> <20110829151333.GA17887@n2100.arm.linux.org.uk>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 30 Aug 2011 02:10:58 +0800
X-Google-Sender-Auth: ESLQrqYx0085BLxnNJ_9SwEmkL0
Message-ID: <CAK5ve-+dEc8ie-pFp8e99rrqxAgWeiW3t30JO_sEBqd3BXeZkg@mail.gmail.com>
Subject: Re: [PATCH v4 00/18] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>, nicolas.pitre@linaro.org,
        arnd@arndb.de, tony@atomide.com, jochen@scram.de,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:13 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Aug 29, 2011 at 09:18:29PM +0800, Bryan Wu wrote:
>> On Mon, Aug 29, 2011 at 7:00 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> > On Fri, Aug 26, 2011 at 11:03 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
>> >
>> >> Based on Linus Walleij's ARM LED consolidation work, this patchset introduce a
>> >> new generic led trigger for CPU not only for ARM but also for others.
>> >
>> > I think Russell was pretty clear that he saw problems inside the "new LEDs"
>> > subsystem (drivers/leds) that need be fixed before we migrate this support
>> > to use the LED class devices.
>> >
>> > Can you see if you can address his comment on the earlier realview patch,
>> > i.e. this:
>> > http://marc.info/?l=linux-arm-kernel&m=131237280009775&w=2
>> >
>>
>> Yeah, I replied that email with a patch to select LEDS_CLASS when
>> CONFIG_NEW_LEDS=y.
>
> I don't see any point to that:
>

Actually, what I really want to propose is to kill this option and
build in leds-class.c when CONFIG_NEW_LEDS=y, since most of functions
of leds-class.c are widely used by others.

And you know, to select it as default is a simple workaround.

Thanks,
-Bryan
