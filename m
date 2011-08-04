Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1HDMxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:53:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39710 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752568Ab1HDMxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:53:30 -0400
Date: Thu, 4 Aug 2011 21:53:22 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org
Subject: Re: [Patch 01/11] MFD: DA9052 Code refactored to use regmap
Message-ID: <20110804125320.GA10451@opensource.wolfsonmicro.com>
References: <1312461902.4384.0.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312461902.4384.0.camel@L-0532.kpit.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 06:15:02PM +0530, ashishj3 wrote:

> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -350,6 +350,7 @@ config MFD_DA9052_SPI
>  	bool "Support Dialog Semiconductor DA9052 PMIC with SPI"
>  	select MFD_CORE
>  	select PMIC_DA9052
> +	select REGMAP_SPI
>  	depends on SPI_MASTER=y
>  	help
>  	  Support for the Dialog Semiconductor DA9052 PMIC

This is an incremental patch against a driver that's not yet been
merged.  As has been pointed out before you should send the complete
patch when submitting drivers that have not yet been merged.
