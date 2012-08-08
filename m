Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab2HHInN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:43:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39796 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab2HHInJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <502179EA.30301@wwwdotorg.org>
References: <1344341538-32223-1-git-send-email-linus.walleij@stericsson.com>
	<502179EA.30301@wwwdotorg.org>
Date: Wed, 8 Aug 2012 10:43:06 +0200
Message-ID: <CACRpkdZ+SsMzAGotOVZ5HrOEQUDs-8ixBYwuLu1ff6Qe=84OdA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/nomadik: add ASIC DB8450 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Patrice Chotard <patrice.chotard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 10:26 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

>> @@ -1722,6 +1722,8 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
>>       /* Poke in other ASIC variants here */
>>       if (version == PINCTRL_NMK_DB8500)
>>               nmk_pinctrl_db8500_init(&npct->soc);
>> +     if (platid->driver_data == PINCTRL_NMK_DB8540)
>> +             nmk_pinctrl_db8540_init(&npct->soc);
>
> I'm surprised one of those checks "version" and the other
> "platid->driver_data".
>
> Aside from that, this looks fine.

Bah, I'll fix this, then add your ACK.

Yours,
Linus Walleij
