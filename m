Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1EBPj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:39:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:2056 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1EBPjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:39:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,303,1301900400"; 
   d="scan'208";a="636767834"
Date: Mon, 2 May 2011 17:39:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Add ASIC3 LED support
Message-ID: <20110502153951.GH8222@sortiz-mobl>
References: <E1QGERz-0007fX-2a@outmx08.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QGERz-0007fX-2a@outmx08.plus.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sat, Apr 30, 2011 at 05:59:25PM +0000, Paul Parsons wrote:
> Add LED support for the HTC ASIC3. Underlying support is provided by the mfd/asic3 and leds/leds-asic3 drivers. 
>
Where is the LED driver ?

> -static int asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
> +static void asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
>  {
>  	unsigned long flags;
>  	u32 cdex;
> @@ -596,8 +596,6 @@ static int asic3_clk_enable(struct asic3
>  		asic3_write_register(asic, ASIC3_OFFSET(CLOCK, CDEX), cdex);
>  	}
>  	spin_unlock_irqrestore(&asic->lock, flags);
> -
> -	return 0;
>  }
Although a valid change, this is unrelated to this patch.

> @@ -883,6 +940,7 @@ static int __init asic3_probe(struct pla
>  		goto out_unmap;
>  	}
>  
> +	asic->gpio.label = "asic3";
Ditto.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
