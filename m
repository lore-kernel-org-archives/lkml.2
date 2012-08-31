Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2HaXBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:01:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63810 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab2HaXB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <1346204124.13176.0.camel@phoenix>
References: <1346204124.13176.0.camel@phoenix>
Date: Sat, 1 Sep 2012 01:01:28 +0200
Message-ID: <CACRpkdYVykTCkJ6YB=ZMzTzMvdcQuMeGeiki02R41fHcaEqcVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: mc9s08dz60: Fix build error if I2C=m
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Wu Guoxing <b39297@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 3:35 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Make GPIO_MC9S08DZ60 depend on I2C=y, this fixes below build error:
>
>   LD      init/built-in.o
> drivers/built-in.o: In function `mc9s08dz60_get_value':
> clk-fixed-factor.c:(.text+0x7214): undefined reference to `i2c_smbus_read_byte_data'
> drivers/built-in.o: In function `mc9s08dz60_set':
> clk-fixed-factor.c:(.text+0x727c): undefined reference to `i2c_smbus_read_byte_data'
> clk-fixed-factor.c:(.text+0x72bc): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `mc9s08dz60_i2c_driver_init':
> clk-fixed-factor.c:(.init.text+0x290): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `mc9s08dz60_i2c_driver_exit':
> clk-fixed-factor.c:(.exit.text+0x2c): undefined reference to `i2c_del_driver'
> make: *** [vmlinux] Error 1
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Patch applied.

Freescale folks: yell if you disagree.

Thanks!
Linus Walleij
