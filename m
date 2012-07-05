Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2GENAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:00:42 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39342 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2GENAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <87395x8fh6.wl%kuninori.morimoto.gx@renesas.com>
References: <877gw2uis5.wl%kuninori.morimoto.gx@renesas.com>
	<87d352qymy.wl%kuninori.morimoto.gx@renesas.com>
	<87aa06qykw.wl%kuninori.morimoto.gx@renesas.com>
	<20120614061519.GB22007@linux-sh.org>
	<878vfqqsnw.wl%kuninori.morimoto.gx@renesas.com>
	<877gvaqsfz.wl%kuninori.morimoto.gx@renesas.com>
	<20120614072322.GC22007@linux-sh.org>
	<874nqeqq7g.wl%kuninori.morimoto.gx@renesas.com>
	<87395x8fh6.wl%kuninori.morimoto.gx@renesas.com>
Date: Thu, 5 Jul 2012 15:00:39 +0200
Message-ID: <CACRpkdabU+OevsRCuJ1EAMT3i-Phe774CAqyuaXsRfMjyCsL+g@mail.gmail.com>
Subject: Re: [PATCH 2/2 v3][resend] gpio: pcf857x: enable gpio_to_irq() support
From: Linus Walleij <linus.walleij@linaro.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 4:40 AM, Kuninori Morimoto
<kuninori.morimoto.gx@renesas.com> wrote:

> pcf857x chip has some pins, but interrupt pin is only 1 pin.
> And gpiolib requests 1 interrupt per 1 gpio pin.
>
> Thus, this patch added demuxed irq to pcf857x driver,
> and enabled gpio_to_irq().
>
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
> v2 -> v3
>
>  - used for_each_set_bit()

Applied this v3 version as nothing has been said since.
Paul, scream if you don't like it.

Yours,
Linus Walleij
