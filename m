Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab0GVRS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:18:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50156 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0GVRSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:18:54 -0400
Date: Thu, 22 Jul 2010 10:17:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gregory Bean <gbean@codeaurora.org>
Cc: akpm@linux-foundation.org, david-b@pacbell.net, khali@linux-fr.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] gpio: sx150x: Add Semtech I2C sx150x gpio expander
 driver.
Message-Id: <20100722101753.c73604eb.randy.dunlap@oracle.com>
In-Reply-To: <1279818771-9428-1-git-send-email-gbean@codeaurora.org>
References: <1279818771-9428-1-git-send-email-gbean@codeaurora.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C487D4B.0197:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 10:12:51 -0700 Gregory Bean wrote:

>  drivers/gpio/Kconfig       |   11 +
>  drivers/gpio/Makefile      |    1 +
>  drivers/gpio/sx150x.c      |  645 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/sx150x.h |   78 ++++++
>  4 files changed, 735 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/sx150x.c
>  create mode 100644 include/linux/i2c/sx150x.h
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 7face91..f623953 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -195,6 +195,17 @@ config GPIO_PCF857X
>  	  This driver provides an in-kernel interface to those GPIOs using
>  	  platform-neutral GPIO calls.
>  
> +config GPIO_SX150X
> +	bool "Semtech SX150x I2C GPIO expander"
> +	depends on I2C=y
> +	default n
> +	help
> +	  Say yes here to provide support for Semtech SX150-series I2C
> +	  GPIO expanders. Compatible models include:

Just curious, not complaining, but why does this driver (and some others)
need to be built-in instead of having the option of being built as a
loadable module?


> +	  8 bits:  sx1508q
> +	  16 bits: sx1509q
> +
>  config GPIO_TC35892
>  	bool "TC35892 GPIOs"
>  	depends on MFD_TC35892




---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
