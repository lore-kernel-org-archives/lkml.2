Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1JMOpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:45:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49717 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab1JMOp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:45:29 -0400
Date: Thu, 13 Oct 2011 15:45:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quiinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH v2 4/7] clk: Add simple gated clock
Message-ID: <20111013144515.GD21648@n2100.arm.linux.org.uk>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-5-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316730422-20027-5-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 03:26:59PM -0700, Mike Turquette wrote:
> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> new file mode 100644
> index 0000000..a1d8e79
> --- /dev/null
> +++ b/drivers/clk/clk-gate.c
> @@ -0,0 +1,78 @@
> +/*
> + * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Simple clk gate implementation
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <asm/io.h>

linux/io.h please.
