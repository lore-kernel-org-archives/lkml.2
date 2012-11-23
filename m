Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2KWLM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:12:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:42547 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab2KWLMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:12:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,306,1352102400"; 
   d="scan'208";a="221416144"
Date: Fri, 23 Nov 2012 12:12:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 1/2] mfd: add an AS3711 PMIC MFD driver
Message-ID: <20121123111221.GC12685@sortiz-mobl>
References: <Pine.LNX.4.64.1211221107520.28453@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211221107520.28453@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Thu, Nov 22, 2012 at 11:12:04AM +0100, Guennadi Liakhovetski wrote:
> AS3711 is a PMIC with multiple DCDC and LDO power supplies, GPIOs, an RTC,
> a battery charger and a general purpose ADC. This patch adds support for
> the MFD with support for a regulator driver and a backlight driver.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v2: (Thanks to Mark for review)
> 
>  - Only print chip IDs if they match expected values
>  - Check regmap_read() error
>  - Make platform data optional
> 
>  drivers/mfd/Kconfig        |    9 ++
>  drivers/mfd/Makefile       |    1 +
>  drivers/mfd/as3711.c       |  217 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/as3711.h |  126 +++++++++++++++++++++++++
>  4 files changed, 353 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/as3711.c
>  create mode 100644 include/linux/mfd/as3711.h
Patch applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
