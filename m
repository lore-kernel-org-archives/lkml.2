Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab2LJWoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:44:20 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41711 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2LJWoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:44:18 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 3/3] leds: leds-pwm: Add device tree bindings
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <50C1F783.6090501@ti.com>
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com> <1352731270-27534-4-git-send-email-peter.ujfalusi@ti.com> <20121206100052.EC8293E0E22@localhost> <50C0913B.9070802@ti.com> <20121207133453.800C43E0B87@localhost> <50C1F783.6090501@ti.com>
Date: Mon, 10 Dec 2012 22:37:22 +0000
Message-Id: <20121210223722.461773E08FB@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2012 15:04:51 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> On 12/07/2012 02:34 PM, Grant Likely wrote:
> > It really needs to look like this:
> > 
> > pwmleds {
> > 	compatible = "pwm-leds";
> > 	kpad {
> > 		label = "omap4::keypad";
> > 		max-brightness = <127>;
> > 		pwms = <&twl_pwm 0 7812500>;
> > 	};
> > 	charging {
> > 		label = "omap4:green:chrg";
> > 		max-brightness = <255>;
> > 		pwms = <&twl_pwmled 0 7812500>;
> > 	};
> > };
> 
> OK.
> So What we need to do is export the of_pwm_request() from drivers/pwm/core.c
> Client drivers us of_pwm_request(node, NULL); to get the pwm when booted with DT.
> Works fine on my setup this way and the DTS section looks just as you have
> described.
> Now I need to clean them up and resubmit.

Cool, thanks.

g.

