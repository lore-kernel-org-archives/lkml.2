Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab1JCPse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:48:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:56651 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab1JCPsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:48:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,480,1312182000"; 
   d="scan'208";a="73882931"
Date: Mon, 3 Oct 2011 17:51:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 03/23] mfd/db8500-prcmu: initialize DB8500 PRCMU regs
Message-ID: <20111003155128.GN4118@sortiz-mobl>
References: <1313137670-30683-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313137670-30683-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Aug 12, 2011 at 10:27:50AM +0200, Linus Walleij wrote:
> From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
> 
> Some clocks may be force enabled when we probe the
> driver, but they need to be turned off by default so
> we have a known state. We call this the register
> initialization function if we need more stuff in
> there in the future.
> 
> Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index dcc690e..e2c4a26 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -1840,6 +1840,16 @@ void __init prcmu_early_init(void)
>  	}
>  }
>  
> +static void __init init_prcm_registers(void)
Could we have a less generic function name here ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
