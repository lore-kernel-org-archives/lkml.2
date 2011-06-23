Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab1FWRPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:15:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57260 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab1FWRPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:15:12 -0400
Date: Thu, 23 Jun 2011 10:14:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Don't ask about the TPS65912 core driver in
 Kconfig
Message-Id: <20110623101455.151886c8.randy.dunlap@oracle.com>
In-Reply-To: <1308750838-26534-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1308750838-26534-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E03749A.01F6:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 14:53:58 +0100 Mark Brown wrote:

> The user has to select the I2C and SPI drivers individually and they select
> the core driver for the device so there's no point in presenting the user
> with an option for the core driver.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 5494413..c5edb8b 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -172,7 +172,7 @@ config MFD_TPS6586X
>  	  will be called tps6586x.
>  
>  config MFD_TPS65912
> -	bool "TPS65912 PMIC"
> +	bool
>  	depends on GPIOLIB
>  
>  config MFD_TPS65912_I2C
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
