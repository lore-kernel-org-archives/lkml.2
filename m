Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1LXX0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 18:26:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1LXX0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 18:26:10 -0500
MIME-Version: 1.0
In-Reply-To: <1324327927-6886-1-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-8-git-send-email-robherring2@gmail.com>
	<1324327927-6886-1-git-send-email-robherring2@gmail.com>
Date: Sun, 25 Dec 2011 00:26:09 +0100
Message-ID: <CACRpkdY3=4b4P7N-oK1UyHbY-FEzm=nvaGzuD_28Mbof1msY2Q@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: pl061: convert to use generic irq chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 9:52 PM, Rob Herring <robherring2@gmail.com> wrote:

> From: Rob Herring <rob.herring@calxeda.com>
>
> Convert the pl061 irq_chip code to use the generic irq chip code.
>
> This has the side effect of using 32-bit accesses rather than 8-bit
> accesses to interrupt registers. The h/w TRM and testing seem to indicate
> this is fine.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.ml.walleij@gmail.com>
> ---
> v2:
> - put struct irq_chip_generic pointer into struct pl061_gpio instead of domain
> ptr.

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
