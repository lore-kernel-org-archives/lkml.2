Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2GBOm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:42:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:1738 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2GBOm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:42:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172533285"
Date: Mon, 2 Jul 2012 16:53:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marc Reilly <marc@cpdesign.com.au>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Subject: Re: [PATCH] mfd: mc13xxx-spi: fix merge conflict
Message-ID: <20120702145343.GK22065@sortiz-mobl>
References: <1341216180.20054.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341216180.20054.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Jul 02, 2012 at 04:03:00PM +0800, Axel Lin wrote:
> This patch fixes conflict between commit 8ae3559
> "mfd: mc13xxx workaround SPI hardware bug on i.Mx"
> and commit 10c7a5d "mfd: Use devm_* APIs for mc13xxx".
> 
> commit 8ae3559 changes regmap_init_spi to regmap_init.
> So now we need to use devm_regmap_init rather than devm_regmap_init_spi.
Good catch, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
