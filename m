Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab1LHEmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:42:36 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63340 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1LHEmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:42:35 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdaTcAUuoUPkyCO4+KQH3KdRj9jiVKP8UmTp+HLzdX1xLw@mail.gmail.com>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
	<CACRpkdaTcAUuoUPkyCO4+KQH3KdRj9jiVKP8UmTp+HLzdX1xLw@mail.gmail.com>
Date: Thu, 8 Dec 2011 13:42:34 +0900
X-Google-Sender-Auth: 0dnoXoSjzWpkyd5H5iiLDj394sw
Message-ID: <CAH9JG2UbVo3aSBpUO1nG-hr37+Wn8_YNnedJt1i2b-cazW_nnA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Minkyu Kang <mk7.kang@samsung.com>, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/7/11, Linus Walleij <linus.walleij@linaro.org> wrote:
> Hm, as we're speaking and debating where these switches should go,
> it appears tasty drivers doing this or similar things are already actively
> being merged into drivers/misc/fsa9480.c:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a1bb73d76bc814e9385390e6aa9880d884322e2e
>
> Given both come from Samsung, is this driver intended to replace
> that custom driver or is this another initiative altogether?
Previous time we used the fsa9480, micro usb IC, and now used the
similar IC, integrated at PMIC. With the restriction and no framework
for proper switching, at that time use the platform callback function,
but with the multistate switch class, we can improve and handle it
more precisely

>
> Minkyu, Donggeun, can you help us finding out where
> these things belong? I guess you guys also have a strong interest
> in a standard solution derived from Android.

Both are my team, and Donggeun is working on *similar IC* with
multistate switch framework.

Thank you,
Kyungmin Park
>
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
