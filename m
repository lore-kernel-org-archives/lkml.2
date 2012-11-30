Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2K3Kzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:55:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:64943 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab2K3Kzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:55:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="224702882"
Date: Fri, 30 Nov 2012 11:55:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: grant.likely@secretlab.ca, rabin.vincent@stericsson.com,
        shiraz.hashim@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        lee.jones@linaro.org, linus.walleij@linaro.org
Subject: Re: [PATCH V4 Resend 1/3] mfd: stmpe: Get rid of irq_invert_polarity
Message-ID: <20121130105526.GM3176@sortiz-mobl>
References: <d1f012d7bb2835f696fc100073f2eb16d9f6204d.1354128258.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1f012d7bb2835f696fc100073f2eb16d9f6204d.1354128258.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Thu, Nov 29, 2012 at 12:17:15AM +0530, Viresh Kumar wrote:
> Since the very first patch, stmpe core driver is using irq_invert_polarity as
> part of platform data. But, nobody is actually using it in kernel till now.
> 
> Also, this is not something part of hardware specs, but is included to cater
> some board mistakes or quirks.
> 
> So, better get rid of it. This is earlier discussed here:
> 
> https://lkml.org/lkml/2012/11/27/636
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> This is actually V1 of this patch.
> 
>  drivers/mfd/stmpe.c       | 7 -------
>  include/linux/mfd/stmpe.h | 2 --
>  2 files changed, 9 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
