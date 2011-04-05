Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1DEQeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:34:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57602 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab1DEQeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:34:15 -0400
Date: Tue, 5 Apr 2011 17:33:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de
Subject: Re: [PATCH] leds: provide helper to register "leds-gpio" devices
Message-ID: <20110405163338.GA11832@n2100.arm.linux.org.uk>
References: <20110405073030.GI13963@pengutronix.de> <1301992655-8514-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1301992655-8514-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 10:37:35AM +0200, Uwe Kleine-König wrote:
> +struct platform_device *__init gpio_led_register_device(
> +		const struct gpio_led_platform_data *pdata);

Please don't add __init annotations to declarations.

