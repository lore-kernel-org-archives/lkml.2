Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052Ab2JSKWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:22:37 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56850 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2JSKWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:22:36 -0400
MIME-Version: 1.0
In-Reply-To: <20121018062208.GB4513@S2101-09.ap.freescale.net>
References: <1350415376-3217-1-git-send-email-linus.walleij@linaro.org>
	<20121018062208.GB4513@S2101-09.ap.freescale.net>
Date: Fri, 19 Oct 2012 12:22:34 +0200
Message-ID: <CACRpkdaNK5+5oQNmmyyF+bD=jJYXbHAJF6e8Xn3jtcR4hoXwrw@mail.gmail.com>
Subject: Re: [PATCH 4/7] gpio/mxs: convert to use linear irqdomain
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 8:22 AM, Shawn Guo <shawn.guo@linaro.org> wrote:

>>       /* gpio-mxs can be a generic irq chip */
>>       mxs_gpio_init_gc(port, irq_base);
>                                ^^^^^^^^
>
> So I know this one is not compile-tested.

No, which defconfig shall I use for this driver?

> This is exactly the reason why I have to use irq_domain_add_legacy
> other than irq_domain_add_linear when I add irqdomain support for the
> driver.  The driver uses generic-irq infrastructural which needs
> irq_base for setup.  So sadly, before generic-irq gets improved, any
> irq chip that uses generic-irq will have to use irq_domain_add_legacy.

Bah, I'm dropping this and a lot of the other patches as well.

I obviously do not understand the inner transcendental meaning of
irqdomains yet.

Yours,
Linus Walleij
