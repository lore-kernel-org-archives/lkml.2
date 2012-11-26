Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2KZLgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:36:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49128 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab2KZLgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:36:49 -0500
Message-ID: <50B35443.2040801@ti.com>
Date: Mon, 26 Nov 2012 12:36:35 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com> <20121123075537.A14713E0A91@localhost> <50AF3E21.4000009@ti.com> <50AF4584.7020604@ti.com> <50B344D6.8030608@metafoo.de>
In-Reply-To: <50B344D6.8030608@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On 11/26/2012 11:30 AM, Lars-Peter Clausen wrote:
> The difference here is that the LED, backlight, etc are all different
> physical devices begin driven by the pwm pin, so it makes sense to have a
> device tree node for them, while using the pwm as gpio is just a different
> function of the same physical pin.  So in a sense the pwm controller also
> becomes a gpio controller. I like the idea of the pwm core automatically
> instantiating a pwm-gpo device if it sees a gpio-controller property in the
> pwm device devicetree node.

OK, fair enough. I will go with the plan I described in the first mail for the
GPIO use of PWM.

-- 
Péter
