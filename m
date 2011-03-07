Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1CGRBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:01:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58421 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1CGRBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:01:48 -0500
Date: Mon, 7 Mar 2011 09:00:17 -0800
From: Randy Dunlap <randy.dunlap@Oracle.COM>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH v3 1/4] MAX8997/8966 MFD Driver Initial Release
 (PMIC+RTC+MUIC+Haptic+...)
Message-Id: <20110307090017.79e7746a.randy.dunlap@oracle.com>
In-Reply-To: <1299493651-25832-2-git-send-email-myungjoo.ham@samsung.com>
References: <1299493651-25832-1-git-send-email-myungjoo.ham@samsung.com>
	<1299493651-25832-2-git-send-email-myungjoo.ham@samsung.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0204.4D750F64.0229,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 19:27:28 +0900 MyungJoo Ham wrote:

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index fd01836..c682ad1 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -293,6 +293,18 @@ config MFD_MAX8925
>  	  accessing the device, additional drivers must be enabled in order
>  	  to use the functionality of the device.
>  
> +config MFD_MAX8997
> +	bool "Maxim Semiconductor MAX8997/8966 PMIC Support"
> +	depends on I2C=y && GENERIC_HARDIRQS
> +	select MFD_CORE
> +	help
> +	  Say yes here to support for Maxim Semiconductor MAX8998/8966.
> +	  This is a Power Management IC with RTC, Flash, Fuel Gauge, Haptic,
> +	  MUIC controls on chip.
> +	  This driver provies common support for accessing the device,

	              provides                                 device;

> +	  additional drivers must be enabled in order to use the functionality
> +	  of the device.
> +
>  config MFD_MAX8998
>  	bool "Maxim Semiconductor MAX8998/National LP3974 PMIC Support"
>  	depends on I2C=y && GENERIC_HARDIRQS

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
