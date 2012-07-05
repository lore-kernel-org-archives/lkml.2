Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2GEMyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:54:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35674 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2GEMyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:54:05 -0400
MIME-Version: 1.0
In-Reply-To: <1339402360-12533-1-git-send-email-stigge@antcom.de>
References: <1339402360-12533-1-git-send-email-stigge@antcom.de>
Date: Thu, 5 Jul 2012 14:54:05 +0200
Message-ID: <CACRpkdYgHnA+EO25UbwBAtjDgyfS2zGGsHhiCtSYpZ0L14yN1A@mail.gmail.com>
Subject: Re: [PATCH] gpio: LPC32xx: Driver cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:12 AM, Roland Stigge <stigge@antcom.de> wrote:

> Since LPC32xx is now switched over to devicetree based GPIO, the unused
> lpc32xx_gpio_init() can be removed.
>
> Further, the driver title changed since it referred to the wrong file.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied.

Thanks,
Linus Walleij
