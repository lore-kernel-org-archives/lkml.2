Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1ITIpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:45:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57111 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1ITIpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:45:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMPhdO9eL_Sdq-=TCami=CkwWeYR3XeF0K=n9L0uzjS88YTsRA@mail.gmail.com>
References: <1312978697-18572-1-git-send-email-linus.walleij@stericsson.com>
	<CAMPhdO9eL_Sdq-=TCami=CkwWeYR3XeF0K=n9L0uzjS88YTsRA@mail.gmail.com>
Date: Tue, 20 Sep 2011 10:45:49 +0200
Message-ID: <CACRpkdbGfhZnLaP9p27T1qbD0NVsW7Spp9ZVbR6zEGBSFU+M9g@mail.gmail.com>
Subject: Re: [PATCH 15/19] plat-pxa: break out GPIO driver specifics
From: Linus Walleij <linus.walleij@linaro.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 4:38 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Wed, Aug 10, 2011 at 8:18 PM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> The <mach/gpio.h> file is included from upper directories
>> and deal with generic GPIO and gpiolib stuff. Break out the
>> platform and driver specific defines and functions into its own
>> header file.
>>
>> Cc: Eric Miao <eric.y.miao@gmail.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> I think there is better way around this, am working on it with several
> patches already, will release soon.

Anything happening on this front or shall I update this patch set?

Yours,
Linus Walleij
