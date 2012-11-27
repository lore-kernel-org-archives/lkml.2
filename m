Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab2K0IpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:45:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:38419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758458Ab2K0IpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:45:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,326,1352102400"; 
   d="scan'208";a="254853615"
Date: Tue, 27 Nov 2012 09:45:01 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65090: MFD_TPS65090 needs to select REGMAP_IRQ
Message-ID: <20121127084501.GY12685@sortiz-mobl>
References: <1354000517.20368.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354000517.20368.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Nov 27, 2012 at 03:15:17PM +0800, Axel Lin wrote:
> This fixes below build error:
> 
> drivers/built-in.o: In function `tps65090_i2c_probe':
> drivers/mfd/tps65090.c:180: undefined reference to `regmap_add_irq_chip'
> drivers/mfd/tps65090.c:190: undefined reference to `regmap_irq_chip_get_base'
> drivers/mfd/tps65090.c:203: undefined reference to `regmap_del_irq_chip'
> drivers/built-in.o: In function `tps65090_i2c_remove':
> drivers/mfd/tps65090.c:213: undefined reference to `regmap_del_irq_chip'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
Applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
