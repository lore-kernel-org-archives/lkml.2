Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072Ab2KNPyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:54:33 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62027 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2KNPyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:54:32 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: omap2-mcspi: remove duplicated include from spi-omap2-mcspi.c
To: Wei Yongjun <weiyj.lk@gmail.com>, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd_rNn_bJ8BJOwcq8EmEi-BQcoakHmQpHG+NdOdDgPSMpQ@mail.gmail.com>
References: <CAPgLHd_rNn_bJ8BJOwcq8EmEi-BQcoakHmQpHG+NdOdDgPSMpQ@mail.gmail.com>
Date: Wed, 14 Nov 2012 15:54:27 +0000
Message-Id: <20121114155427.957923E0B1A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012 21:29:21 +0800, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.

Applied, thanks.

> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)

Since I have to manually remove the above cruft from commit logs, can
you please omit it from the commit text when posting patches?

Thanks,
g.

> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/spi/spi-omap2-mcspi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 474e217..b8b2f03 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -39,7 +39,6 @@
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/pinctrl/consumer.h>
> -#include <linux/err.h>
>  
>  #include <linux/spi/spi.h>
>  
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
