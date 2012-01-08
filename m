Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2AHXGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:06:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:26848 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab2AHXGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:06:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110063103"
Date: Mon, 9 Jan 2012 00:12:37 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] mfd: Add S5M series configuration
Message-ID: <20120108231237.GC13679@sortiz-mobl>
References: <1324628892-12170-1-git-send-email-sbkim73@samsung.com>
 <1324628892-12170-4-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324628892-12170-4-git-send-email-sbkim73@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangbeom,

On Fri, Dec 23, 2011 at 05:28:10PM +0900, Sangbeom Kim wrote:
> This patch add Samsung S5M series configuration.
I applied this one, except that I removed those unrelated entries (for now):

> +config MFD_MAX8698
> +	bool "Maxim Semiconductor MAX8698 PMIC Support"
> +	depends on I2C=y
> +	select MFD_CORE
> +	help
> +	  Say yes here to support for Maxim Semiconductor MAX8698. This is
> +	  a Power Management IC. This driver provies common support for
> +	  accessing the device, additional drivers must be enabled in order
> +	  to use the functionality of the device.
> +
> +config MFD_MAX77686
> +	bool "Maxim Semiconductor MAX77686 PMIC Support"
> +	depends on I2C=y && GENERIC_HARDIRQS
> +	select MFD_CORE
> +	help
> +	  Say yes here to support for Maxim Semiconductor MAX77686.
> +	  This is a Power Management IC with RTC on chip.
> +	  This driver provides common support for accessing the device;
> +	  additional drivers must be enabled in order to use the functionality
> +	  of the device.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
