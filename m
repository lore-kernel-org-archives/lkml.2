Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab1E0VW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:22:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28308 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1E0VWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:22:52 -0400
Message-ID: <4DE015F0.7090601@oracle.com>
Date: Fri, 27 May 2011 14:21:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Liam Girdwood <lrg@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: linux-next: build failure after merge of the voltage tree
References: <201105271759.p4RHxa2X008919@hera.kernel.org>	 <20110527125830.447abb79.randy.dunlap@oracle.com> <1306530788.3366.30.camel@odin>
In-Reply-To: <1306530788.3366.30.camel@odin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DE015FB.0091:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> gah, looks this was broken by moving the tps65910 gpio directory move.
> 
> This should fix it though:-

It does.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> From: Liam Girdwood <lrg@ti.com>
> Date: Fri, 27 May 2011 22:06:52 +0100
> Subject: [PATCH] mfd: tps65910 - fix build breakage caused by tps65910 gpio directory move.
> 
> Signed-off-by: Liam Girdwood <lrg@ti.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b6c2677..0f09c05 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -721,7 +721,7 @@ config MFD_PM8XXX_IRQ
>  
>  config MFD_TPS65910
>  	bool "TPS65910 Power Management chip"
> -	depends on I2C=y
> +	depends on I2C=y && GPIOLIB
>  	select MFD_CORE
>  	select GPIO_TPS65910
>  	help


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
