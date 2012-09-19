Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2ISABa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 20:01:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:16306 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab2ISABZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 20:01:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,446,1344236400"; 
   d="scan'208";a="223728753"
Date: Wed, 19 Sep 2012 02:00:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 7/8] mfd: Use the AB8500's IRQ domain to convert hwirq to
 virq
Message-ID: <20120919000054.GZ3647@sortiz-mobl>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344527635-6163-8-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Thu, Aug 09, 2012 at 04:53:54PM +0100, Lee Jones wrote:
> Before the AB8500 had its own IRQ domain, the IRQ handler would take
> the fired local IRQ (hwirq) and add it to the irq_base to convert it
> to an IRQ number which Linux would understand (virq). However, the
> IRQ base is not always used anymore since we can make use of Linear
> domains. It's better to use the AB8500 hwirq -> virq mapping helper
> function to convert them instead. That's what we do here.
> 
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-core.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
Patch applied now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
