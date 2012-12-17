Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2LQHkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 02:40:47 -0500
Received: from smtp.xy24.at ([85.126.109.136]:58339 "EHLO renate.xy24.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751387Ab2LQHkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 02:40:46 -0500
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 02:40:46 EST
Message-ID: <50CEC9B0.3040503@universalnet.at>
Date: Mon, 17 Dec 2012 08:28:48 +0100
From: Bernd Krumboeck <krumboeck@universalnet.at>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] can: add tx/rx LED trigger support
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com> <1355656113-9562-2-git-send-email-fabio.baltieri@gmail.com>
In-Reply-To: <1355656113-9562-2-git-send-email-fabio.baltieri@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (renate.xy24.at [85.126.109.136]); Mon, 17 Dec 2012 08:29:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fabio!

Am 2012-12-16 12:08, schrieb Fabio Baltieri:
> This patch implements the functions to add two LED triggers, named
> <ifname>-tx and <ifname>-rx, to a canbus device driver.
>
> Triggers are called from specific handlers by each CAN device driver and
> can be disabled altogether with a Kconfig option.
>
> The implementation keeps the LED on when the interface is UP and blinks
> the LED on network activity at a configurable rate.
>
> This only supports can-dev based drivers, as it uses some support field
> in the can_priv structure.
>
> Supported drivers should call devm_can_led_init() and can_led_event() as
> needed.
>
> Cleanup is handled automatically by devres, so no *_exit function is
> needed.
>
> Supported events are:
> - CAN_LED_EVENT_OPEN: turn on tx/rx LEDs
> - CAN_LED_EVENT_STOP: turn off tx/rx LEDs
> - CAN_LED_EVENT_TX: trigger tx LED blink
> - CAN_LED_EVENT_RX: trigger tx LED blink

Why there is no patch for any usb can device?

Can this be done in a more general way, except patching every driver?


regards,
Bernd

