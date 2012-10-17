Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2JQQfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:35:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42674 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab2JQQfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <1350401000-9453-1-git-send-email-s-guiriec@ti.com>
References: <1350401000-9453-1-git-send-email-s-guiriec@ti.com>
Date: Wed, 17 Oct 2012 22:05:50 +0530
Message-ID: <CAM=Q2cu2nA2R_LcMnjkSMJn6coxYQ_EHPSuG9ExbW7pa7fsu8A@mail.gmail.com>
Subject: Re: [PATCH] i2c: omap: adopt pinctrl support
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Sebastien Guiriec <s-guiriec@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 8:53 PM, Sebastien Guiriec <s-guiriec@ti.com> wrote:
> Some GPIO expanders need some early pin control muxing. Due to
> legacy boards sometimes the driver uses subsys_initcall instead of
> module_init. This patch takes advantage of defer probe feature
> and pin control in order to wait until pin control probing before
> GPIO driver probing. It has been tested on OMAP5 board with TCA6424
> driver.
>
> log:
>
> [0.482299] omap_i2c i2c.15: could not find pctldev for node /ocp/pinmux@4a00
> 2840/pinmux_i2c5_pins, deferring probe
> [0.482330] platform i2c.15: Driver omap_i2c requests probe deferral
> [0.484466] Advanced Linux Sound Architecture Driver Initialized.
>
> [4.746917] omap_i2c i2c.15: bus 4 rev2.4.0 at 100 kHz
> [4.755279] gpiochip_find_base: found new base at 477
> [4.761169] gpiochip_add: registered GPIOs 477 to 500 on device: tca6424a
>
Thanks,

Acked-by: Shubhrajyoti D <shubhrajyoti@ti.com>
