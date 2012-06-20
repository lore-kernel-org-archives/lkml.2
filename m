Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2FTOdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:33:18 -0400
Received: from linux-sh.org ([111.68.239.195]:42051 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab2FTOdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:33:17 -0400
Date: Wed, 20 Jun 2012 23:31:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, Rohit Vaswani <rvaswani@codeaurora.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Richard Woo <richard.wu@lianlab.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
Message-ID: <20120620143140.GA7817@linux-sh.org>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
 <20110808081552.GI32513@linux-sh.org>
 <CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
 <CAH9JG2V-66Wn7nwJz6tOkESoQAUJzAg-47YeMY0vzwu6T9O=Rg@mail.gmail.com>
 <4E40912C.5040801@codeaurora.org>
 <CACRpkdZUxYP0Mbe+heEwrZE5VC+J42g_-QAusrOsUuBPT324Hw@mail.gmail.com>
 <CAGsJ_4y38KBDfjZS_k-QfDUUFAtEwE-ciUgNOA0U2juOBeoXEA@mail.gmail.com>
 <CACRpkdazTKs_sNHVkVAYdz6CK9fwghf2n-Rrs7fi7R1Z=Gt+3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdazTKs_sNHVkVAYdz6CK9fwghf2n-Rrs7fi7R1Z=Gt+3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 10:15:01AM +0200, Linus Walleij wrote:
> On Tue, Jun 19, 2012 at 5:25 AM, Barry Song <21cnbao@gmail.com> wrote:
> > but i think at least the macros of GPIO_PULL_NONE, GPIO_PULL_UP and
> > GPIO_PULL_DOWN should be standardized.
> 
> You find an attempt at standardization in drivers/pinctrl/pinconf-generic.c
> which is also used by the composite U300+COH901 drivers. Drivers
> can select this support library and use the flags from
> <linux/pinctrl/pinconf-generic.h>
> 
What's with PIN_CONFIG_END using such an insane value?

I'm happy to consolidate on the provided definitions and add my own on top
of that, but I'm not going to waste an insane amount of bits that I could
be using for driver-specific data and so on instead to comply with the
PIN_CONFIG_END comment. Is there any valid reason why this would ever
need to exceed 4 bits?
