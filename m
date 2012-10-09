Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2JIGH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:07:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59860 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558Ab2JIGHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:07:24 -0400
Date: Tue, 9 Oct 2012 15:07:12 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, linus.walleij@linaro.org,
        swarren@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: tps6586x: add irq io-resource for rtc sub driver
Message-ID: <20121009060710.GF8237@opensource.wolfsonmicro.com>
References: <1349712805-10014-1-git-send-email-ldewangan@nvidia.com>
 <1349712805-10014-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349712805-10014-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 09:43:24PM +0530, Laxman Dewangan wrote:
> Add IRQ IORESOURCE for rtc sub driver of this device.
> The rtc driver can get the irq by calling platform_get_irq().
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
