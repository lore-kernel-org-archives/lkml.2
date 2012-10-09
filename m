Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2JIGIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:08:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59876 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548Ab2JIGHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:07:55 -0400
Date: Tue, 9 Oct 2012 15:07:46 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, linus.walleij@linaro.org,
        swarren@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: tps6586x: implement gpio_to_irq
Message-ID: <20121009060744.GG8237@opensource.wolfsonmicro.com>
References: <1349712805-10014-1-git-send-email-ldewangan@nvidia.com>
 <1349712805-10014-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349712805-10014-4-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 09:43:25PM +0530, Laxman Dewangan wrote:
> The TPS6586x adds the interrupt of this device using
> linear mapping on irq domain.
> Hence, implement gpio_to_irq to get the irq number
> corresponding to TPS6586x GPIOs which is created
> dynamically.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
