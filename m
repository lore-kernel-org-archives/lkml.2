Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2JDL01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 07:26:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47164 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754935Ab2JDL00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 07:26:26 -0400
Date: Thu, 4 Oct 2012 12:26:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        arnd@arndb.de, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/6] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
Message-ID: <20121004112623.GL4360@opensource.wolfsonmicro.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349320509-26930-1-git-send-email-festevam@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 12:15:04AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> On a mx53qsb dt-kernel the da9052-core driver fails to probe as follows:
> 
> da9052 1-0048: DA9052 ADC IRQ failed ret=-22
> 
> The reason for the error was due to passing only the offset as the interrupt
> number in request_threaded_irq() without da9052->irq_base.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
