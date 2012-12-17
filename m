Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2LQUVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:21:10 -0500
Received: from smtp.xy24.at ([85.126.109.136]:37947 "EHLO renate.xy24.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753141Ab2LQUVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:21:08 -0500
Message-ID: <86fd45485e2016d2c5ad27f28669195e.squirrel@webmail.universalnet.at>
In-Reply-To: <20121217174121.GA16327@balto.lan>
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
    <1355656113-9562-2-git-send-email-fabio.baltieri@gmail.com>
    <50CEC9B0.3040503@universalnet.at> <20121217174121.GA16327@balto.lan>
Date: Mon, 17 Dec 2012 21:20:57 +0100
Subject: Re: [PATCH 1/9] can: add tx/rx LED trigger support
From: =?iso-8859-1?Q?=22Bernd_Krumb=F6ck=22?= <krumboeck@universalnet.at>
To: "Fabio Baltieri" <fabio.baltieri@gmail.com>,
        "Bernd Krumboeck" <krumboeck@universalnet.at>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        "Kurt Van Dijck" <kurt.van.dijck@eia.be>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        "Oliver Hartkopp" <socketcan@hartkopp.net>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.4 (renate.xy24.at [127.0.0.1]); Mon, 17 Dec 2012 21:20:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Bernd,
>
> On Mon, Dec 17, 2012 at 08:28:48AM +0100, Bernd Krumboeck wrote:
>> Why there is no patch for any usb can device?
>
> Because USB canbus interfaces usually already has some dedicated
> activity LED on the device itself, while this patch is meant to give an
> equivalent functionality for Embedded SoC with GPIO based LEDs, so I
> just started by modifying some Embedded CAN drivers.
>
> If you think it's useful for USB controller, just tell me or modify the
> driver by yourself!  As you see the patch is really easy.

At least it is useful for the usb_8dev driver. I'll write a patch.

Photo of the device:
http://www.8devices.com/product/2/usb2can

>> Can this be done in a more general way, except patching every driver?
>
> Actually this started as a generic patch bolted to the CAN stack, but
> the implementation was too invasive and a bit too hacky.  A generic
> implementation at can-dev level is hard to obtain because the can-dev
> layer is not used in all the device operation, as the most of the driver
> calls generick network API directly.
>

Thanks!

regards,
Bernd
