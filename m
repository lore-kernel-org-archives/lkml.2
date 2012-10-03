Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044Ab2JCS2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:28:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55213 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964869Ab2JCS2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:28:07 -0400
Date: Wed, 3 Oct 2012 19:28:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: sameo@linux.intel.com, marex@denx.de, dchen@diasemi.com, arnd@arndb.de,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        fabio.estevam@freescale.com
Subject: Re: [PATCH] [PATCH v3] mfd: da9052-core:  Use regmap_irq_get_virq()
 and fix the probe
Message-ID: <20121003182804.GI4360@opensource.wolfsonmicro.com>
References: <1349271193.9129.2.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349271193.9129.2.camel@dhruva>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 07:03:13PM +0530, Ashish Jangam wrote:
> Fix for da9052-core driver probe fail on a mx53qsb dt-kernel
> da9052 1-0048: DA9052 ADC IRQ failed ret=-22
> 
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
