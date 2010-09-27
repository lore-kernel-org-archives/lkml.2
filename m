Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab0I0N3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:29:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:5734 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225Ab0I0N3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,243,1283756400"; 
   d="scan'208";a="661508114"
Date: Mon, 27 Sep 2010 15:29:39 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Declare abx500_remove_ops()
Message-ID: <20100927132938.GG2560@sortiz-mobl>
References: <1285163910-1789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285163910-1789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Sep 22, 2010 at 02:58:30PM +0100, Mark Brown wrote:
> Otherwise sparse warns about a public symbol with no declaration and
> the compiler can't spot if the callers and users have different signatures
> for the function.
Patch applied, thanks for spotting this.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/mfd/abx500.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
> index be7373c..67bd6f7 100644
> --- a/include/linux/mfd/abx500.h
> +++ b/include/linux/mfd/abx500.h
> @@ -229,4 +229,5 @@ struct abx500_ops {
>  };
>  
>  int abx500_register_ops(struct device *core_dev, struct abx500_ops *ops);
> +void abx500_remove_ops(struct device *dev);
>  #endif
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
