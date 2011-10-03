Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1JCPuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:50:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:47846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab1JCPuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:50:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="58498204"
Date: Mon, 3 Oct 2011 17:53:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/23] mfd/db8500-prcmu: add watchdog accessor functions
Message-ID: <20111003155316.GQ4118@sortiz-mobl>
References: <1313137713-30848-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313137713-30848-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Aug 12, 2011 at 10:28:33AM +0200, Linus Walleij wrote:
> +int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
> +{
> +	BUG_ON(num == 0 || num > 0xf);
> +	return prcmu_a9wdog(MB4H_A9WDOG_CONF, num, 0, 0,
> +			    sleep_auto_off ? A9WDOG_AUTO_OFF_EN :
> +			    A9WDOG_AUTO_OFF_DIS);
> +}
> +
> +int prcmu_enable_a9wdog(u8 id)
> +{
> +	return prcmu_a9wdog(MB4H_A9WDOG_EN, id, 0, 0, 0);
> +}
> +
> +int prcmu_disable_a9wdog(u8 id)
> +{
> +	return prcmu_a9wdog(MB4H_A9WDOG_DIS, id, 0, 0, 0);
> +}
> +
> +int prcmu_kick_a9wdog(u8 id)
> +{
> +	return prcmu_a9wdog(MB4H_A9WDOG_KICK, id, 0, 0, 0);
> +}
So I suppose you will eventually export those symbols ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
