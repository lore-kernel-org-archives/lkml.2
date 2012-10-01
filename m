Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab2JAKWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:22:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38524 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195Ab2JAKWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:22:48 -0400
Date: Mon, 1 Oct 2012 11:22:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, sameo@linux.intel.com,
        Marek Vasut <marex@denx.de>, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
Message-ID: <20121001102246.GE4360@opensource.wolfsonmicro.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
 <20120928104944.GB30869@opensource.wolfsonmicro.com>
 <5065B534.7040602@freescale.com>
 <20120928142924.GA22101@opensource.wolfsonmicro.com>
 <CAOMZO5DgOjs06BJZWsEay-jP5pjzMNTZTZnvAvzAd-JD9kqs1g@mail.gmail.com>
 <20120928155121.GA22510@opensource.wolfsonmicro.com>
 <CAOMZO5CZ68vozBi4CZwLqFZreb9-Egnx6vi9RBGxgKJB+B2qwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CZ68vozBi4CZwLqFZreb9-Egnx6vi9RBGxgKJB+B2qwg@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 05:34:18PM -0300, Fabio Estevam wrote:

> +static struct irq_chip da9052_irq_chip = {
> +	.name			= "da9052",
> +	.irq_disable		= da9052_irq_disable,
> +	.irq_enable		= da9052_irq_enable,
> +};

I don't understand what this irq_chip or the custom domain you're adding
are for?
