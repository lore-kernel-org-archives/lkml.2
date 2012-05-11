Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2EKL5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:57:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57198 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab2EKL5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:57:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1205102211060.1957@localhost6.localdomain6>
References: <1336644082-14137-1-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdbA58UiNLZRPWe1yGckGFrXqtJ3ddqjLLzLntC6+Cin3g@mail.gmail.com>
	<alpine.DEB.2.02.1205102211060.1957@localhost6.localdomain6>
Date: Fri, 11 May 2012 13:57:42 +0200
Message-ID: <CACRpkda7=kaN53yHT0JML_QQZMYKESEPSh0D5D-3m7hHups6kw@mail.gmail.com>
Subject: Re: [PATCH] gpio/langwell: re-read the IRQ status register after each iteration
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:34 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:

> I tried the following:
>
> @@
> expression pending,gedr,e1;
> statement S;
> @@
>
> *pending = readl(gedr);
> ... when != pending = e1
> while (pending) S
>
> That is, a readl call followed by a while loop with no reassignment of
> pending.
>
> Perhaps the following are suspicious:
>
> arch/arm/mach-msm/dma.c, function msm_datamover_irq_handler
> drivers/gpio/gpio-msm-v1.c, function msm_gpio_irq_handler
>
> But I am not completely sure to understand what is wanted (or not wanted).

No problem, I will look at them.
Thanks Julia!

Yours,
Linus Walleij
