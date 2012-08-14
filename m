Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2HNWSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:18:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48615 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2HNWSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:18:48 -0400
MIME-Version: 1.0
In-Reply-To: <1343530482.5373.2.camel@phoenix>
References: <1343530482.5373.2.camel@phoenix>
Date: Wed, 15 Aug 2012 00:18:47 +0200
Message-ID: <CACRpkdYsFC+3+1P2sfab3viDUkkEXUgwOO6i2CUexkrA_K0X5g@mail.gmail.com>
Subject: Re: [PATCH RFT 1/2] gpio: gpio-ml-ioh: Use spinlock for register
 access protection
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 4:54 AM, Axel Lin <axel.lin@gmail.com> wrote:

> gpio_chip.can_sleep is 0, but current code uses mutex in ioh_gpio_set,
> ioh_gpio_get and ioh_gpio_direction_input functions.
> Thus those functions are not callable from interrupt context.
> This patch converts mutex into spinlock.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied to my devel branch for the next merge window, it doesn't
seem like a regression to me atleast.

Yours,
Linus Walleij
