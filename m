Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab2EKJKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:10:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:13822 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183Ab2EKJKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:10:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98890290"
Date: Fri, 11 May 2012 11:19:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Michel JAOUEN <michel.jaouen@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 5/6 v2] mfd/ab8500: support of hierachical interrupt
Message-ID: <20120511091756.GB1214@sortiz-mobl>
References: <1336395723-32138-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336395723-32138-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, May 07, 2012 at 03:02:03PM +0200, Linus Walleij wrote:
> From: Michel JAOUEN <michel.jaouen@stericsson.com>
> 
> Hierarchical interrupt is supported since ab8500 V2.
> However, it is not implemented in the ab8500-core driver.
> With the current implementation, when an ab9540 interrupt
> occurs, 17 Latch registers are read through i2c. With
> hierarchical interrupt implementation, there are only 4 i2c
> accesses.
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
> Reviewed-by: Michel Jaouen <michel.jaouen@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2: unnest the interrupt handler function at
>                   Sam's request. This should apply fine on top
> 		  of the already applied stuff for AB8500 MFD.
Looks much better, thanks.
I applied it to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
