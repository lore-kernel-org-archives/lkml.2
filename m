Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2DBOCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:02:23 -0400
Received: from antcom.de ([188.40.178.216]:49629 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab2DBOCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:02:20 -0400
Message-ID: <4F79B169.5010909@antcom.de>
Date: Mon, 02 Apr 2012 16:02:17 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH 0/7]: arm: lpc32xx: Device tree support
References: <1333371364-21347-1-git-send-email-stigge@antcom.de> <201204021345.04512.arnd@arndb.de>
In-Reply-To: <201204021345.04512.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 04/02/2012 03:45 PM, Arnd Bergmann wrote:
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>
> Looks good overall.

Thanks for your mails, I'm just integrating your suggestions.

> I notice that you are missing the bindings for irq and gpio, which
> tend to be
> quite important. Do you have another tree that has all the lpc32xx
> specific
> parts or are these still under heavy development?

Yes, still under development. GPIO is subject to an open minor issue
(will post an RFC later), and irq is part of the main mach-lpc32xx dt
switch - I have DT-irq already working, but I need to OF'ize lcd and usb
to complete.

> Do you plan to add DT support in parallel to the ATAGS based board you
> already have, or do you plan to move everything over quickly?

For the LPC32xx specific things, including arch/arm/mach-lpc32xx, I will
switch over to DT quickly, eliminating phy3250.c by replacing with a
respective dts file.

The other subsystems changes (pnx*) can and should be dual DT/non-DT to
support other platforms and users who still use it in a non-DT way.

> In the latter case, it might be helpful to get Acks from the subsystem
> maintainers and merge everything through arm-soc.

Yes, sounds reasonable regarding the LPC32xx specific bits like wdt and
adc. Is there sth. I can do about it?

Thanks all,

Roland
