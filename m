Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab1JCIxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:53:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38394 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1JCIxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:53:14 -0400
Date: Mon, 3 Oct 2011 09:52:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] AT91: dt: at91sam9g45 family and board device tree
	files
Message-ID: <20111003085240.GB11710@n2100.arm.linux.org.uk>
References: <1317636056-9537-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317636056-9537-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 12:00:56PM +0200, Nicolas Ferre wrote:
> diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
> new file mode 100644
> index 0000000..7bcb9a9
> --- /dev/null
> +++ b/arch/arm/mach-at91/board-dt.c
> @@ -0,0 +1,122 @@
> +/*
> + *  Setup code for AT91SAM Evaluation Kits with Device Tree support
> + *
> + *  Covers: * AT91SAM9G45-EKES  board
> + *          * AT91SAM9M10-EKES  board
> + *          * AT91SAM9M10G45-EK board
> + *
> + *  Copyright (C) 2011 Atmel,
> + *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/irqdomain.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +
> +#include <mach/hardware.h>
> +#include <mach/board.h>
> +#include <mach/gpio.h>

Is linux/gpio.h broken for you?
