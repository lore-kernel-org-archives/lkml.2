Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1HKNGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:06:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:32945 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1HKNGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:06:08 -0400
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024E04F945@dbde02.ent.ti.com>
References: <1312978639-18339-1-git-send-email-linus.walleij@stericsson.com>
	<B85A65D85D7EB246BE421B3FB0FBB593024E04F945@dbde02.ent.ti.com>
Date: Thu, 11 Aug 2011 15:06:07 +0200
Message-ID: <CACRpkdZvxvD01ofxMxDb3wXpt9_8wkU1rwxdLj5RuidoZNrb+w@mail.gmail.com>
Subject: Re: [PATCH 08/19] mach-davinci: move DaVinci TNET GPIO driver to GPIO subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>, "Hilman, Kevin" <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 12:21 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> Hi Linus,
>
> On Wed, Aug 10, 2011 at 17:47:19, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> As per example from the other ARM boards, push the DaVinci TNET
>> GPIO driver down to the GPIO subsystem so it can be consolidated.
>>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> Cc: Kevin Hilman <khilman@ti.com>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> There should be no need of this since the TNETV107x
> GPIO can simply be supported using the basic MMIO GPIO
> driver. I submitted patches for that a while back
> but have some comments from Grant to address. He requested
> some changes to be done to the basic MMIO GPIO driver
> itself.
>
> https://lkml.org/lkml/2011/7/5/16
>
> I do plan to rework those patches and post them back.

OK I will keep this around in case it doesn't happen
soon, it certainly does not make matters worse
anyway.

Thanks,
Linus Walleij
