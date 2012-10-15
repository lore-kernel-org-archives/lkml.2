Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2JOT4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:56:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61328 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2JOT4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <1350069085-13283-2-git-send-email-stigge@antcom.de>
References: <1350069085-13283-1-git-send-email-stigge@antcom.de>
	<1350069085-13283-2-git-send-email-stigge@antcom.de>
Date: Mon, 15 Oct 2012 21:56:43 +0200
Message-ID: <CACRpkdZ54+Vm36fm=V4p1MhPuU=-=5mk9j7QsCpZYpc1WnY=dQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/6 v3] gpio: Add a block GPIO API to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 9:11 PM, Roland Stigge <stigge@antcom.de> wrote:

> +#define NR_GPIO_BLOCKS 16
> +
> +static struct gpio_block *gpio_block[NR_GPIO_BLOCKS];

16 looks quite arbitrary, as noted elsewhere please use a list.

Yours,
Linus Walleij
