Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0FNLv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:51:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43196 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752369Ab0FNLvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:51:25 -0400
Date: Mon, 14 Jun 2010 12:51:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 V2] gpio: add STMPE811 gpio controller support
Message-ID: <20100614115123.GB14604@rakim.wolfsonmicro.main>
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
 <1276511558-27121-3-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276511558-27121-3-git-send-email-l.fu@pengutronix.de>
X-Cookie: I brake for chezlogs!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:32:37PM +0200, Luotao Fu wrote:

> +static struct gpio_chip gpio_chip = {
> +	.label = STMPE811_GPIO_NAME,
> +	.owner = THIS_MODULE,
> +	.direction_input = stmpe811_gpio_direction_in,
> +	.get = stmpe811_gpio_get,
> +	.direction_output = stmpe811_gpio_direction_out,
> +	.set = stmpe811_gpio_set,
> +	.request = stmpe811_gpio_request,
> +	.can_sleep = 1,
> +};

Assuming you're able to do interrupts on the GPIOs you should now be
able to implement to_irq() as well.
