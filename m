Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2GJItg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:49:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:50276 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab2GJIte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:49:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175419689"
Date: Tue, 10 Jul 2012 11:01:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Guard max77686_pmic_dt_match with CONFIG_OF
Message-ID: <20120710090105.GR15345@sortiz-mobl>
References: <1341844140.8153.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341844140.8153.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Jul 09, 2012 at 10:29:00PM +0800, Axel Lin wrote:
> This fixes below build warning if CONFIG_OF is not set.
> 
>   CC      drivers/mfd/max77686.o
> drivers/mfd/max77686.c:37:42: warning: 'max77686_pmic_dt_match' defined but not used [-Wunused-variable]
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/max77686.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
