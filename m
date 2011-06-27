Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1F0MDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 08:03:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51877 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754659Ab1F0MDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 08:03:05 -0400
Date: Mon, 27 Jun 2011 13:02:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stijn Devriendt <highguy@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kyungmin Park <kmpark@infradead.org>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Ben Nizette <bn@niasdigital.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH 0/2] RFC: gpio: driver-local pin configuration
Message-ID: <20110627120256.GA19531@opensource.wolfsonmicro.com>
References: <1307695731-28018-1-git-send-email-linus.walleij@stericsson.com>
 <BANLkTinxptCJRETreCpUoV-nU2K4fuFcmQ@mail.gmail.com>
 <BANLkTimMSChGFUSnFWFHv3nNUca_Fyawaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimMSChGFUSnFWFHv3nNUca_Fyawaw@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 01:44:43PM +0200, Linus Walleij wrote:

> Yes. To make the driver platform neutral, it needs to for example
> provide a callback in the platform data like (* set_pin_bias) or so,
> and then your platform has to implement this biasing.

> In this specific case that kind of stuff would likely be preferable
> to have in the platform anyway, but I understand what you mean.

How about device tree usage?  I guess there we'd end up doing it by
putting the configuration on the GPIO end of things rather than on the
GPIO user side?
