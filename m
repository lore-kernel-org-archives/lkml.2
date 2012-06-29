Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2F2NKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:10:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:5536 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab2F2NKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:10:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117361925"
Date: Fri, 29 Jun 2012 15:21:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/22] mfd: ab8500-gpadc: Enable IRQF_ONESHOT when
 requesting a threaded IRQ
Message-ID: <20120629132125.GL4846@sortiz-mobl>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-17-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338353260-10097-17-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed, May 30, 2012 at 12:47:34PM +0800, Lee Jones wrote:
> The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-gpadc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
