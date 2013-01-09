Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3AIBt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:49:57 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51296 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab3AIBtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:49:55 -0500
MIME-Version: 1.0
In-Reply-To: <201301081307.04229.arnd@arndb.de>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
 <1357629535-26033-3-git-send-email-acourbot@nvidia.com> <201301081307.04229.arnd@arndb.de>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Wed, 9 Jan 2013 10:49:33 +0900
X-Google-Sender-Auth: tsFFvYsXCBoiJG0K-DO24k4Kga4
Message-ID: <CAAVeFu+1jYVTH7+cgRHb8LjQCJhSMZ9vR1=m+AH06bp+7Z4+fw@mail.gmail.com>
Subject: Re: [PATCH 2/4] gpiolib: add gpiod_get and gpiod_put functions
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 10:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 08 January 2013, Alexandre Courbot wrote:
>>
>> Adds new GPIO allocation functions that work with the opaque descriptor
>> interface.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>
> I think you need to reorder the patches slightly, since the gpiod_get
> function introduced here is already being used in the first patch, which
> breaks bisection.

Yes, gpiod_get and gpiod_put should only appear from the second patch
on. Thanks for pointing that out.

Alex.
