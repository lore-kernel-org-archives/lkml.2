Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab1LGJb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:31:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56038 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1LGJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <201111281753.45287.arnd@arndb.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
Date: Wed, 7 Dec 2011 10:31:25 +0100
Message-ID: <CACRpkdaTcAUuoUPkyCO4+KQH3KdRj9jiVKP8UmTp+HLzdX1xLw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Minkyu Kang <mk7.kang@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: myungjoo.ham@gmail.com, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm, as we're speaking and debating where these switches should go,
it appears tasty drivers doing this or similar things are already actively
being merged into drivers/misc/fsa9480.c:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a1bb73d76bc814e9385390e6aa9880d884322e2e

Given both come from Samsung, is this driver intended to replace
that custom driver or is this another initiative altogether?

Minkyu, Donggeun, can you help us finding out where
these things belong? I guess you guys also have a strong interest
in a standard solution derived from Android.

Yours,
Linus Walleij
