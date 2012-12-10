Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab2LJThi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:37:38 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43549 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2LJThh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:37:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121210184819.GA15484@roeck-us.net>
References: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
	<CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
	<20121207145955.GA28704@roeck-us.net>
	<20121207164906.08b65046@pyramind.ukuu.org.uk>
	<CACRpkdY2qht8Yxs2gzjHoxxqcqOP_v=-73OBmNfyO0qr1n+7MQ@mail.gmail.com>
	<20121210184819.GA15484@roeck-us.net>
Date: Mon, 10 Dec 2012 11:37:35 -0800
Message-ID: <CAK7N6vq8+H=Y1hD0vMEEiY6CtGkZivnmDKiwiuG12s9kf7y5qw@mail.gmail.com>
Subject: Re: [PATCH] gpio: export 'debounce' attribute if supported by the
 gpio chip
From: anish singh <anish198519851985@gmail.com>
To: Guenter Roeck <groeck-dsl@sbcglobal.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 10:48 AM, Guenter Roeck
<groeck-dsl@sbcglobal.net> wrote:
> On Mon, Dec 10, 2012 at 11:04:09AM +0100, Linus Walleij wrote:
>> On Fri, Dec 7, 2012 at 5:49 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>
>> >> I could imagine declaring the activity request buttons to be "input", but for
>> >> presence detects it is a bit far fetched and would add too much complexity.
>> >
>> > Android tries to address this with its switch class driver, but I'm not
>> > sure its actually got anything over making them input devices.
>>
>> This has actually been merged into the kernel proper as drivers/extcon.
>>
>> So another poke on Günther if this fulfills the needs?
>>
> I'll look into it. Currently I am hampered by a cold which seems to mug my
> brain, and technically by the need to backport extcon to 3.0 (if that is even
> possible) since our chip vendor does not yet support a more recent kernel.
It is very much possible.I have already tried that and it works.
>
> Thanks,
> Guenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
