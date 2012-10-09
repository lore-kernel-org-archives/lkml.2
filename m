Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2JIGG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:06:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59856 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222Ab2JIGGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:06:53 -0400
Date: Tue, 9 Oct 2012 15:06:43 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, linus.walleij@linaro.org,
        swarren@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: Convert tps6586x to irq_domain
Message-ID: <20121009060641.GE8237@opensource.wolfsonmicro.com>
References: <1349712805-10014-1-git-send-email-ldewangan@nvidia.com>
 <1349712805-10014-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349712805-10014-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 09:43:23PM +0530, Laxman Dewangan wrote:
> Allocate the irq base if it base is not porvided i.e.
> in case of device tree invocation of this driver.
> Convert the tps6586x driver to irq domain, using a
> legacy IRQ mapping if an irq_base is specified in
> platform data or dynamically allocated and otherwise
> using a linear mapping.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but can you convert to regmap_irq?
