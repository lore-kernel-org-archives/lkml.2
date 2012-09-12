Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2ILPpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:45:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58610 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2ILPp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <87fw6nn7gx.wl%kuninori.morimoto.gx@renesas.com>
References: <20120912031131.GA22076@localhost>
	<87fw6nn7gx.wl%kuninori.morimoto.gx@renesas.com>
Date: Wed, 12 Sep 2012 17:45:28 +0200
Message-ID: <CACRpkdYagWXN4zOEVNK==kR96R2x7qjM7UX-NmUhtPwEyx=L_A@mail.gmail.com>
Subject: Re: [PATCH] gpio: pcf857x: fixup smatch WARNING
From: Linus Walleij <linus.walleij@linaro.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 7:19 AM, Kuninori Morimoto
<kuninori.morimoto.gx@renesas.com> wrote:

> 6e20a0a429bd4dc07d6de16d9c247270e04e4aa0
> (gpio: pcf857x: enable gpio_to_irq() support)
> added new smatch warnings
>
> drivers/gpio/gpio-pcf857x.c:288 pcf857x_probe() error: we previously \
>         assumed 'pdata' could be null (see line 277)
> drivers/gpio/gpio-pcf857x.c:364 pcf857x_probe() warn: variable dereferenced\
>          before check 'pdata' (see line 292)
> drivers/gpio/gpio-pcf857x.c:421 pcf857x_remove() error: we previously\
>          assumed 'pdata' could be null (see line 410)
>
> This patch fixes it
>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Applied, thanks!
Linus Walleij
