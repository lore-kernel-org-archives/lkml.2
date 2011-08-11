Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1HKUeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:34:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64307 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab1HKUeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:34:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6435"; a="109536594"
Date: Thu, 11 Aug 2011 13:34:16 -0700
From: David Brown <davidb@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Manuel Lauss <manuel.lauss@gmail.com>, Pavel Pisa <ppisa@pikron.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        Ben Dooks <ben-linux@fluff.org>, Chris Ball <cjb@laptop.org>,
        Alex Dubov <oakad@yahoo.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] mmc: Use pr_<level>, add and use mmc_<level>
Message-ID: <20110811203416.GA12740@huya.qualcomm.com>
References: <1441985db03ab10b067332f7d4b75b607921441b.1313094012.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1441985db03ab10b067332f7d4b75b607921441b.1313094012.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 01:21:24PM -0700, Joe Perches wrote:
> Use current logging styles.
> 
> Add an mmc_printk function to reduce overall size
> by centralizing the mmc_hostname use.
> 
> Because pr_fmt(fmt) KBUILD_MODNAME is used,
> some logging prefixes are changed.
> For instance from "SDIO:" to "mmc_core:"
> 
> Add macros for mmc_err, mmc_warn, and mmc_info.
> Convert printks with mmc_hostname to mmc_<level>.
> 
> Whitespace neatening around pr_<level>.
> Convert printk(KERN_DEBUG to pr_debug(
> Convert direct uses of DBG macros to pr_debug.
> Convert direct uses of DBGF to DBG.
> Coalesce long format strings.
> Add a few missing newlines to logging messages.
> 
> $ size drivers/mmc/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>   92530	   1608	    204	  94342	  17086	drivers/mmc/built-in.o.minimal.new
>   94229	   1608	    204	  96041	  17729	drivers/mmc/built-in.o.minimal.old
>  291831	   5152	  77344	 374327	  5b637	drivers/mmc/built-in.o.allyesconfig.new
>  293616	   5152	  78128	 376896	  5c040	drivers/mmc/built-in.o.allyesconfig.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mmc/host/msm_sdcc.c     |  103 +++++++++----------

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
