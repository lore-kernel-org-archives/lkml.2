Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767721Ab2KONE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:04:26 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53424 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993283Ab2KONEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:04:25 -0500
MIME-Version: 1.0
In-Reply-To: <201211150919.37343.arnd@arndb.de>
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org>
	<201211130911.09613.arnd@arndb.de>
	<20121113112430.GF28341@n2100.arm.linux.org.uk>
	<201211150919.37343.arnd@arndb.de>
Date: Thu, 15 Nov 2012 07:04:24 -0600
X-Google-Sender-Auth: GsC2Hzq_yqTPx46b7DZQyv7ytvI
Message-ID: <CAF6AEGv-O_D6nOnEwi5w8NUcv+dQFe7pJBXhUA8xq+tykG4dfg@mail.gmail.com>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
From: Rob Clark <rob.clark@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 3:19 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 13 November 2012, Russell King - ARM Linux wrote:
>> You're missing something; that is one of the greatest powers of open
>> source.  The many eyes (and minds) effect.  Someone out there probably
>> has a solution to whatever problem, the trick is to find that person. :)
>>
>> I think we have a working solution for this for ARM.  It won't be suitable
>> for every arch, where they have 8-bit and 16-bit registers able to be
>> allocated by the compiler, but for architectures where the minimum register
>> size is 32-bit, what we have below should work.
>
> I don't mind at all adding the extension to ARM, and I think it's pretty
> cool that you guys actually found a working solution.
>
> The part that worries me is that we are making architecture independent
> code depend on a clever hack that may or may not be possible to implement
> on a given architecture, and that most architecture maintainers wouldn't
> know how to implement correctly even if it's possible.

I could always send a 3rd version with a comment smashed on about why
that works if you think this is a problem..

BR,
-R

>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
