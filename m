Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747Ab2FGLLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 07:11:23 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48836 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759492Ab2FGLLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 07:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <1338916327-3958-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1338916327-3958-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 7 Jun 2012 13:11:20 +0200
Message-ID: <CACRpkdY379kHbaMhGD4Q9y=Nkv2NPey+n1zUuTLAE-j7f8gadA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: wm8994: Pay attention to the value set when
 enabling as output
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 7:12 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> +       if (value)
> +               value = WM8994_GPN_LVL;
> +
>        return wm8994_set_bits(wm8994, WM8994_GPIO_1 + offset,
> -                              WM8994_GPN_DIR, 0);
> +                              WM8994_GPN_DIR | WM8994_GPN_LVL, value);
>  }

The commit message is so terse compared to what the code does that
I cannot claim to understand what this patch is doing.

Could you elaborate on the problem ans symptoms, just for a nice
commit log?

Yours,
Linus Walleij
