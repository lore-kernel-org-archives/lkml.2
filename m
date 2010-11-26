Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0KZLBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:01:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:18038 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab0KZLBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:01:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,260,1288594800"; 
   d="scan'208";a="630496461"
Date: Fri, 26 Nov 2010 12:01:12 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] drivers/mfd: Use printf extension %pR for struct
 resource
Message-ID: <20101126110111.GG5520@sortiz-mobl>
References: <cover.1289597644.git.joe@perches.com>
 <c6c8909d879beb258d2de7d25e82c30673f29ffe.1289597644.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6c8909d879beb258d2de7d25e82c30673f29ffe.1289597644.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Fri, Nov 12, 2010 at 01:37:56PM -0800, Joe Perches wrote:
> Using %pR standardizes the struct resource output.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Patch applied, thanks.

Cheers,
Samuel.


> ---
>  drivers/mfd/sm501.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
> index bc9275c..78638cf 100644
> --- a/drivers/mfd/sm501.c
> +++ b/drivers/mfd/sm501.c
> @@ -745,11 +745,8 @@ static int sm501_register_device(struct sm501_devdata *sm,
>  	int ret;
>  
>  	for (ptr = 0; ptr < pdev->num_resources; ptr++) {
> -		printk(KERN_DEBUG "%s[%d] flags %08lx: %08llx..%08llx\n",
> -		       pdev->name, ptr,
> -		       pdev->resource[ptr].flags,
> -		       (unsigned long long)pdev->resource[ptr].start,
> -		       (unsigned long long)pdev->resource[ptr].end);
> +		printk(KERN_DEBUG "%s[%d] %pR\n",
> +		       pdev->name, ptr, &pdev->resource[ptr]);
>  	}
>  
>  	ret = platform_device_register(pdev);
> -- 
> 1.7.3.1.g432b3.dirty
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
