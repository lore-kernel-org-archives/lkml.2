Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2BTLH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:07:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:23907 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab2BTLHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:07:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127360767"
Date: Mon, 20 Feb 2012 12:15:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: Fix section mismatch warning for da9052-spi
Message-ID: <20120220111505.GS5387@sortiz-mobl>
References: <1326274036.8938.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326274036.8938.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Jan 11, 2012 at 05:27:16PM +0800, Axel Lin wrote:
> Add __devinit annotation for da9052_spi_probe to fix below build warning:
> 
> WARNING: drivers/built-in.o(.text+0x349b4): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init()
> The function da9052_spi_probe() references
> the function __devinit da9052_device_init().
> This is often because da9052_spi_probe lacks a __devinit
> annotation or the annotation of da9052_device_init is wrong.
> 
> Also add __devexit annotation for da9052_spi_remove because we have
> __devexit_p around it in the remove callback.
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
