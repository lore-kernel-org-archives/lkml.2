Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab2GNT5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 15:57:19 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54527 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2GNT5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 15:57:09 -0400
MIME-Version: 1.0
In-Reply-To: <1340836334-20427-1-git-send-email-stigge@antcom.de>
References: <1340836334-20427-1-git-send-email-stigge@antcom.de>
Date: Sat, 14 Jul 2012 21:57:08 +0200
Message-ID: <CACRpkdYrZizqvZqsocLEGrkY5yPMuYFfmR3UUSFZgPDvEPa0eA@mail.gmail.com>
Subject: Re: [PATCH RESEND] gpio: of_get_named_gpio_flags() return
 -EPROBE_DEFER if GPIO not yet available
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: cjb@laptop.org, rob.herring@calxeda.com, rmk+kernel@arm.linux.org.uk,
        ulf.hansson@stericsson.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 12:32 AM, Roland Stigge <stigge@antcom.de> wrote:

> of_get_named_gpio_flags() and of_get_named_gpio() return -EPROBE_DEFER if the
> respective GPIO is not (yet) available. This is useful if driver's probe()
> functions try to get a GPIO whose controller isn't probed yet. Thus, the driver
> can be probed again later on.
>
> The function still returns -EINVAL on other errors (parse error or node doesn't
> exist). This way, the case of an optional/intentionally missing GPIO is handled
> appropriately.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

If I understand correctly this relates closely to another patch from Mark Brown
we discussed the other day (sorry for missing this patch, which arrived
earlier, for a while).

Mark/Grant can you look at this patch?

Yours,
Linus Walleij
