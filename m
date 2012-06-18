Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2FRR0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:26:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34928 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2FRR0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:26:33 -0400
Message-ID: <4FDF64C4.8060308@wwwdotorg.org>
Date: Mon, 18 Jun 2012 11:26:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: broonie@opensource.wolfsonmicro.com, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org, lrg@ti.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org
Subject: Re: [PATCH] sound/gpio: of_get_named_gpio() return -EPROBE_DEFER
 if GPIO deferred
References: <1340040176-16553-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1340040176-16553-1-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 11:22 AM, Roland Stigge wrote:
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

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

(That applies to the two separate sound patches too, if needed!)
