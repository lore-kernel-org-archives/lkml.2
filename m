Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab0GaItV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 04:49:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58201 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0GaItS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 04:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Oekx38FLXnEf5+PxNZMbBed+BJpM2xpbWbHw9aGbUQNc1uClGQCE7zF0vkhRRrw6jU
         BO7fTmvE/6H7Ys7/jZ3PIp+coprktmB+fh6nqNXfRYzMHuTJ0EA4FMbKWYr9dI5pH2am
         OeBdC6L1cSjs062ZZ+40GWWUJq+b82IwGx4KY=
MIME-Version: 1.0
In-Reply-To: <20100730163457.a54cb0f1.akpm@linux-foundation.org>
References: <1277194762-21399-1-git-send-email-rabin.vincent@stericsson.com>
	<AANLkTin-EGaq9q0ATgRfm=XKTgJ7EYT_Q-Ruzr_OQXsY@mail.gmail.com>
	<20100730163457.a54cb0f1.akpm@linux-foundation.org>
Date: Sat, 31 Jul 2010 10:49:17 +0200
X-Google-Sender-Auth: IPa2-sMNoHB3t7LtJ3srrLKrffY
Message-ID: <AANLkTi=AyRucpxCXf1Mg1TDtM+ru9QjVqpV+OhndeBxf@mail.gmail.com>
Subject: Re: [PATCH] mmc: only set blockaddressed for > 2GiB cards
From: Linus Walleij <linus.walleij@stericsson.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        Hanumath Prasad <hanumath.prasad@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/31 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 30 Jul 2010 19:28:44 +0200
> Linus Walleij <linus.walleij@stericsson.com> wrote:
>
>> 2010/6/22 Rabin Vincent <rabin.vincent@stericsson.com>:
>>
>> > From: Hanumath Prasad <hanumath.prasad@stericsson.com>
>> >
>> > A non-zero value of SEC_COUNT does not indicate that the card is sector
>> > addressed. __According to the MMC specification, cards with a density
>> > greater than 2GiB are sector addressed.
>>
>> What's happening with this beauty? Andrew would you mind
>> picking this one up please?
>
> I merged that a month ago, for 2.6.36.

Aha sorry I didn't see it, it wasn't in -next I rely too much on that tree
I believe. I'll check directly in your patchstack for stuff henceforth.

Thanks and sorry for the trouble!

Yours,
Linus Walleij
