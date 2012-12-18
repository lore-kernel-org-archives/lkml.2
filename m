Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2LRGCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:02:20 -0500
Received: from smtp.xy24.at ([85.126.109.136]:45240 "EHLO renate.xy24.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750950Ab2LRGCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:02:12 -0500
Message-ID: <92a8e5e68e38c059d3a29b5ed4252da8.squirrel@webmail.universalnet.at>
In-Reply-To: <20121217214222.GA3539@balto.lan>
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
    <1355656113-9562-2-git-send-email-fabio.baltieri@gmail.com>
    <50CEC9B0.3040503@universalnet.at> <20121217174121.GA16327@balto.lan>
    <86fd45485e2016d2c5ad27f28669195e.squirrel@webmail.universalnet.at>
    <20121217214222.GA3539@balto.lan>
Date: Tue, 18 Dec 2012 07:02:02 +0100
Subject: Re: [PATCH 1/9] can: add tx/rx LED trigger support
From: =?iso-8859-1?Q?=22Bernd_Krumb=F6ck=22?= <krumboeck@universalnet.at>
To: "Fabio Baltieri" <fabio.baltieri@gmail.com>,
        =?iso-8859-1?Q?=22Bernd_Krumb=F6ck=22?= <krumboeck@universalnet.at>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        "Kurt Van Dijck" <kurt.van.dijck@eia.be>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        "Oliver Hartkopp" <socketcan@hartkopp.net>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.4 (renate.xy24.at [127.0.0.1]); Tue, 18 Dec 2012 07:02:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio!

> On Mon, Dec 17, 2012 at 09:20:57PM +0100, "Bernd Krumböck" wrote:
>> > If you think it's useful for USB controller, just tell me or modify
>> the
>> > driver by yourself!  As you see the patch is really easy.
>>
>> At least it is useful for the usb_8dev driver. I'll write a patch.
>>
>> Photo of the device:
>> http://www.8devices.com/product/2/usb2can
>
> Sure that it's needed?  That status LED is probably controlled directly
> by the firmware itself.  Anyway I think it makes sense to support all
> the mainline drivers and I'm really happy if you test the patch on
> your hardware!

Yes, it is controlled by the firmware, but it does not show rx/tx. Whereas
my OpenWRT hardware has enough leds. ;-)

regards,
Bernd
