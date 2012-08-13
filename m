Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2HMMBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:01:33 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55957 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2HMMBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:01:32 -0400
MIME-Version: 1.0
In-Reply-To: <1343530482.5373.2.camel@phoenix>
References: <1343530482.5373.2.camel@phoenix>
Date: Mon, 13 Aug 2012 14:01:31 +0200
Message-ID: <CACRpkdaLUCe8_cuYh_pq7HUKkWhaSXS6xEU=ZwbpoUcy9nCz4w@mail.gmail.com>
Subject: Re: [PATCH RFT 1/2] gpio: gpio-ml-ioh: Use spinlock for register
 access protection
From: Linus Walleij <linus.walleij@linaro.org>
To: Feng Tang <feng.tang@intel.com>, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Axel Lin <axel.lin@gmail.com>
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

So IOH guys what are you saying about this?

If you say nothing I will apply these patches.

Yours,
Linus Walleij
