Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab2F2OkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:40:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:43832 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab2F2OkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:40:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159731623"
Date: Fri, 29 Jun 2012 16:51:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Subject: Re: [PATCH 07/14] mfd: Initialise the AB8500 driver at core_initcall
 time
Message-ID: <20120629145110.GC22806@sortiz-mobl>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339428307-3850-8-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Jun 11, 2012 at 04:25:00PM +0100, Lee Jones wrote:
> The AB8500 is soon to have its own IRQ domain. For this to be useful
> the driver needs to be initialised earlier in the boot sequence. Here
> we move initialisation forward from arch_initcall to core_initcall time.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
