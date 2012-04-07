Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2DGOTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 10:19:09 -0400
Received: from antcom.de ([188.40.178.216]:58460 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab2DGOTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 10:19:06 -0400
Message-ID: <4F804CD8.70803@antcom.de>
Date: Sat, 07 Apr 2012 16:19:04 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH v2] gpio: Device tree support for LPC32xx
References: <1333497518-25838-1-git-send-email-stigge@antcom.de> <20120407035327.9D7923E246E@localhost> <4F80460E.50605@antcom.de>
In-Reply-To: <4F80460E.50605@antcom.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/12 15:50, Roland Stigge wrote:
> Hi Grant,
...

> Please consider how the groups are specified in
> drivers/gpio/gpio-lpc32xx.c. They each have different numbers of lines
> and GPIO / GPI / GPO functionality. So they also have different callback
> sets, and we need to do separate gpiochip_add()s which leads to the
> separate gpio-bank specifications in the dtsi file. Separate enabling of
> those banks via OF are a nice by-product.

And BTW: This also corresponds nicely with how the LPC32xx hardware
calls its GPIOs, e.g. GPO 3 for GPO #3 in the gpo group.

Thanks for considering,

Roland
