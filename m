Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2GPUtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:49:20 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44790 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2GPUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:49:18 -0400
MIME-Version: 1.0
In-Reply-To: <87ipdnein1.fsf@ti.com>
References: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
	<1341997995-14020-3-git-send-email-tarun.kanti@ti.com>
	<87394xhocn.fsf@ti.com>
	<CACRpkdZMG_ZHW_eGGrdrJh1SuO_=hOObijzmxG1ob6RoNf_dwg@mail.gmail.com>
	<87a9z4g9bi.fsf@ti.com>
	<CACRpkdZxUpQ=a-yQ8b4bnX3S9penPWkxJ+PG2Zi4i9YZibYRiw@mail.gmail.com>
	<87ipdnein1.fsf@ti.com>
Date: Mon, 16 Jul 2012 22:49:17 +0200
Message-ID: <CACRpkdYMzdjFXBMs6do-yqiBFV5ru28SftA5u+ZkP5KO+PhjCA@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio/omap: add *remove* callback in platform_driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Hilman <khilman@ti.com>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 7:10 PM, Kevin Hilman <khilman@ti.com> wrote:

> Subject: [PATCH] MAINTAINERS: add entry OMAP GPIO driver
>
> Since I've been maintaining this, making it official at the request of the
> GPIO maintainers.
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kevin Hilman <khilman@ti.com>

Thank! Applied, but:

> +F:     drivers/gpio/gpio.omap.c

I replaced the period with a dash:
drivers/gpio/gpio-omap.c

Yours,
Linus Walleij
