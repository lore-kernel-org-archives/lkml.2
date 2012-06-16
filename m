Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2FPPGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 11:06:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44395 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2FPPGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 11:06:38 -0400
Message-ID: <4FDCA0FC.5000409@wwwdotorg.org>
Date: Sat, 16 Jun 2012 09:06:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: riku.voipio@iki.fi, bryan.wu@canonical.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] leds: Add DT support for leds-pca9532
References: <1339855851-9171-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1339855851-9171-1-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2012 08:10 AM, Roland Stigge wrote:
> This patch adds DT support for leds-pca9532.

> +++ linux-2.6/Documentation/devicetree/bindings/leds/leds-pca9532.txt

> +- nxp,typecodes: groups of 2 bits for each of the 16 pins:
> +  0: None
> +  1: LED
> +  2: Beep
> +  3: GPIO
> +- nxp,statecodes: groups of 2 bits for each of the 16 pins:
> +  0: off
> +  1: on
> +  2: pwm0
> +  3: pwm1
> +
> +Optional properties:
> +- nxp,psc: array of 2 numbers: PSC values for the two PWM channels (see datasheet)
> +- nxp,pwm: array of 2 numbers: PWM values for the two PWM channels (see datasheet)

Shouldn't that all be exposed using a combination of the pinctrl
bindings that are in 3.5, and the PWM bindings that should be coming in 3.6?
