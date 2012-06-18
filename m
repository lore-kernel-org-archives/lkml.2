Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2FRR3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:29:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34740 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2FRR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:29:09 -0400
MIME-Version: 1.0
In-Reply-To: <1340040176-16553-1-git-send-email-stigge@antcom.de>
References: <1340040176-16553-1-git-send-email-stigge@antcom.de>
Date: Mon, 18 Jun 2012 14:29:07 -0300
Message-ID: <CAAAP30E6GAc4p_G7vZBUDFqdWy+ay0ZP9dGCJ586VysOLe66Mw@mail.gmail.com>
Subject: Re: [PATCH] sound/gpio: of_get_named_gpio() return -EPROBE_DEFER if
 GPIO deferred
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: broonie@opensource.wolfsonmicro.com, swarren@wwwdotorg.org, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lrg@ti.com, perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 2:22 PM, Roland Stigge <stigge@antcom.de> wrote:
> of_get_named_gpio_flags() and of_get_named_gpio() return -EPROBE_DEFER if the
> respective GPIO is not (yet) available. This is useful if driver's probe()
> functions try to get a GPIO whose controller isn't probed yet. Thus, the driver
> can be probed again later on.
>
> The function still returns -EINVAL on other errors (parse error or node doesn't
> exist). This way, the case of an optional/intentionally missing GPIO is handled
> appropriately.
>
> For this change, two sound drivers (tegra_{alc5632,wm8903}) need to be
> adjusted.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
