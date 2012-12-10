Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2LJKa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:30:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51967 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2LJKaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:30:55 -0500
Date: Mon, 10 Dec 2012 10:30:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 11/12] ARM: ux500: Use the GPIO regulator framework for
 SDI0's 'en' and 'vsel'
Message-ID: <20121210103050.GE9362@gmail.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
 <1355129761-8088-12-git-send-email-lee.jones@linaro.org>
 <CAPDyKFo8NjiYdcyx3pk8byc1N2f7r+erQj74A1zhOaNK_WbkZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFo8NjiYdcyx3pk8byc1N2f7r+erQj74A1zhOaNK_WbkZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +        .constraints = {
> > +                .min_uV         = 1800000,
> 
> 2.9V, not 3.3V

> > +static struct gpio_regulator_state sdi0_reg_states[] = {
> > +        { .value = 3300000, .gpios = (0 << 0) },
> 
> 2.9V, not 3.3V

I'm still a little unsure about this. I know the actual
voltage is v2.9, but the supported/requested MMC voltage
from the driver is v3.3.

Will it still work if I set it all up as v2.9?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
