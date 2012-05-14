Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2ENUxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:53:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:27137 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038Ab2ENUxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:53:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140550162"
Date: Mon, 14 May 2012 23:03:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Convert regmap_irq to use irq_domain
Message-ID: <20120514210334.GH12740@sortiz-mobl>
References: <1336920889-22516-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336920889-22516-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, May 13, 2012 at 03:54:49PM +0100, Mark Brown wrote:
> This gets us up to date with the recommended current kernel infrastructure
> and should transparently give us device tree interrupt bindings for any
> devices using the framework. If an explicit IRQ mapping is passed in then
> a legacy interrupt range is created, otherwise a simple linear mapping is
> used.
> 
> A function regmap_irq_get_virq() is provided to allow drivers to map
> individual IRQs which should be used in preference to the existing
> regmap_irq_chip_get_base() since it avoids the need to create the mappings
> for the full range of interrupts.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
