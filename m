Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2LSJx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:53:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:16946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab2LSJxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:53:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="233781907"
Date: Wed, 19 Dec 2012 11:56:17 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: chao bi <chao.bi@intel.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        sylvain.centelles@intel.com, ken.k.mills@intel.com,
        jun.d.chen@intel.com, alan@linux.intel.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] SPI: SSP SPI Controller driver v3
Message-ID: <20121219095616.GV2261@intel.com>
References: <1355818296.11831.287.camel@bichao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355818296.11831.287.camel@bichao>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 04:11:36PM +0800, chao bi wrote:
> 
> This patch is to implement SSP SPI controller driver, which has been applied and
> validated on intel Moorestown & Medfield platform. The patch are originated by
> Ken Mills <ken.k.mills@intel.com> and Sylvain Centelles <sylvain.centelles@intel.com>,
> migrating to lateset Linux mainline SPI framework by Channing <chao.bi@intel.com>
> and Chen Jun <jun.d.chen@intel.com> according to their integration & validation
> on Medfield platform.

This is the same IP block as used in PXA, right? With few modifications
here and there. Is there a reason not to use spi-pxa2xx.c?

I have a set of patches for spi-pxa2xx.c that adds support for Lynxpoint
LPSS, DMA engine and ACPI enumeration. I'm hoping to send those soon (once
-rc1 is released) to the list.

Maybe we can co-operate to get the Medfield support there as well?
