Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2FLLIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:08:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42817 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2FLLIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:08:42 -0400
Message-ID: <4FD72336.9040803@linaro.org>
Date: Tue, 12 Jun 2012 12:08:38 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: nomadik: fix up typo
References: <1339498592-1435-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1339498592-1435-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/12 11:56, Linus Walleij wrote:
> Commit a60b57eddaa8af6c02cf7bbeb58ebf82881f08ac
> "drivers/gpio: gpio-nomadik: Add support for irqdomains"
> changed GPIO offset calculations to have this form:
> (gpio % NMK_GPIO_PER_CHIP) except in this one place for
> setting sleep mode, where the conversion was all wrong, and
> instead mod:ing the GPIO with the IRQ base which does not
> make any sense.
>
> So fix this up so we can use sleepmode.
>
> Cc: Lee Jones<lee.jones@linaro.org>
> Signed-off-by: Linus Walleij<linus.walleij@stericsson.com>

Makes sense.

Reviewed-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
