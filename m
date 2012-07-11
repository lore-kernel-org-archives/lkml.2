Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2GKIoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:44:39 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52139 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2GKIog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:44:36 -0400
MIME-Version: 1.0
In-Reply-To: <4FFD12C5.9090204@xenotime.net>
References: <20120710174320.3b7dd806e20ee74ca1b1685f@canb.auug.org.au>
	<4FFD12C5.9090204@xenotime.net>
Date: Wed, 11 Jul 2012 10:44:35 +0200
Message-ID: <CACRpkdY2CdHr+oMyckR_ozJ69vpzpyuC75qDwDLPi4Og2UD-7g@mail.gmail.com>
Subject: Re: linux-next: Tree for July 10 (gpio/gpio-tps65910.c)
From: Linus Walleij <linus.walleij@linaro.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 7:44 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 07/10/2012 12:43 AM, Stephen Rothwell wrote:
>>
>> Changes since 20120709:
>
> when CONFIG_OF_GPIO is not enabled:
>
> drivers/gpio/gpio-tps65910.c: In function 'tps65910_gpio_probe':
> drivers/gpio/gpio-tps65910.c:152:26: error: 'struct gpio_chip' has no member named 'of_node'

I have a patche queued for this and even attempted to send it to Torvalds.
It will be in tomorrows -next anyway.

Yours,
Linus Walleij
