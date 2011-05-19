Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab1ESVTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:19:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:31716 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab1ESVTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:19:06 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1305839942!23328148!15
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Sascha Hauer <s.hauer@pengutronix.de>, Shawn Guo <shawn.guo@freescale.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jamie Iles <jamie@jamieiles.com>
Date: Thu, 19 May 2011 16:18:56 -0500
Subject: RE: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Thread-Topic: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Thread-Index: AcwWWMzATUTICBiaRLe0WX/xfnghAgAEKBIg
Message-ID: <0D753D10438DA54287A00B027084269764D3045B3B@AUSP01VMBX24.collaborationhost.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<20110519085638.GA26816@S2100-06.ap.freescale.net>
	<BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
	<20110519135631.GB26816@S2100-06.ap.freescale.net>
 <20110519191156.GE2429@pengutronix.de>
In-Reply-To: <20110519191156.GE2429@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 19, 2011 12:12 PM, Sascha Hauer wrote:
> On Thu, May 19, 2011 at 09:56:32PM +0800, Shawn Guo wrote:
>> On Thu, May 19, 2011 at 02:21:27PM +0200, Linus Walleij wrote:
>>> On Thu, May 19, 2011 at 10:56 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
>>> 
>>>> I start working on moving mxs gpio (arch/arm/mach-mxs/gpio.c) into
>>>> driver/gpio, and I see the possibility to go a different approach
>>>> from U300 one posted here.
>>> 
>>> I've tried to figure out what relation the mail has to the U300 driver
>>> but cannot find any, more than that it's moving a driver... Please
>>> start a new mail thread.
>>> 
>> I will post mxs-gpio driver once I get it done.  Then please review
>> the code and see the difference between mxs-gpio and u300-gpio,
>> though these hardwares have something in common.
>
> I'm pretty sure they have something in common and even more that *all*
> gpio drivers have something in common. I wonder if it really makes sense
> to move the gpio driver to drivers/gpio without creating a common
> mmio_gpio_chip beforehand. This can't be very hard.

Jamie Iles (cc'ed) posted some patches that extended the basic_mmio_gpio
driver so that it could be used as a library by other gpio drivers.

Jamie, could you re-post that series to the linux-arm-kernel list for
review?

Thanks,
Hartley