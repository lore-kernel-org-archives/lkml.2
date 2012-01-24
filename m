Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2AXQcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:32:25 -0500
Received: from antcom.de ([188.40.178.216]:56551 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2AXQcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:32:24 -0500
Message-ID: <4F1EDD15.7010704@antcom.de>
Date: Tue, 24 Jan 2012 17:32:21 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, Kevin Wells <kevin.wells@nxp.com>
Subject: Re: [PATCH] Correct bad gpio naming
References: <4F1C4E25.6070801@antcom.de> <20120124155921.GH2609@pengutronix.de>
In-Reply-To: <20120124155921.GH2609@pengutronix.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/24/2012 04:59 PM, Wolfram Sang wrote:
> On Sun, Jan 22, 2012 at 06:57:57PM +0100, Roland Stigge wrote:
>> One of the GPIO names in drivers/gpio/gpio-lpc32xx.c was bad.
>> Renaming gpi000 -> gpio00
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> Since you are modifying LPC32xx :) Which kernel version do you run?
> I was trying to get a board up with 3.0 (not booting) and 3.3-rc1
> (build breakage). I even thought about removing that mach, since
> vital parts seem to be missing (Net, NAND) or broken. So, I am
> interested if there are still users.

I'm actively maintaining an LPC32xx machine line (WORK Microwave GmbH
devices) at http://git.antcom.de/ - feel free to merge from there.

For me, it works fine with Linux 3.2.0.

The repo includes some additional features like NAND (esp. MLC
controller, while NXP implemented an SLC driver), High Speed UARTs and
ADC. Some of those are not yet integrated mainline, but I'm willing to
help here. Looks like I will maintain it anyway for the next few years.

Expect the first one of the drivers to be submitted soon, I will do
them one by one.

Thanks for keeping LPC32xx :-)

Roland
