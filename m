Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1K1FlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 00:41:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:3359 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab1K1FlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 00:41:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,582,1315206000"; 
   d="scan'208";a="79655603"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Liu, Hong" <hong.liu@intel.com>, Daniel Drake <dsd@laptop.org>,
        Matthew Garrett <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Date: Mon, 28 Nov 2011 11:10:30 +0530
Subject: RE: [PATCH] platform-drivers-x86: convert drivers/platform/x86/* to
 use module_platform_driver()
Thread-Topic: [PATCH] platform-drivers-x86: convert drivers/platform/x86/*
 to use module_platform_driver()
Thread-Index: Acyr8fC2rwTXyUg4TXKgSxTEcR0MeABneY+A
Message-ID: <D6D887BA8C9DFF48B5233887EF04654109F12EC332@bgsmsx502.gar.corp.intel.com>
References: <1322280877.6458.3.camel@phoenix>
In-Reply-To: <1322280877.6458.3.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAS5fObH030277

Hi,

Thanks for the nice clean up for intel_mid_thermal.c

>From which kernel version is this new macro supported ?

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Saturday, November 26, 2011 9:45 AM
> To: linux-kernel@vger.kernel.org
> Cc: Liu, Hong; R, Durgadoss; Daniel Drake; Matthew Garrett; platform-driver-
> x86@vger.kernel.org
> Subject: [PATCH] platform-drivers-x86: convert drivers/platform/x86/* to use
> module_platform_driver()
> 
> This patch converts the drivers in drivers/platform/x86/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Hong Liu <hong.liu@intel.com>
> Cc: Durgadoss R <durgadoss.r@intel.com>
> Cc: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---


Acked-by: Durgadoss R <Durgadoss.r@intel.com>

> diff --git a/drivers/platform/x86/intel_mid_thermal.c
> b/drivers/platform/x86/intel_mid_thermal.c
> index ccd7b1f..e4cc992 100644
> --- a/drivers/platform/x86/intel_mid_thermal.c
> +++ b/drivers/platform/x86/intel_mid_thermal.c
> @@ -565,18 +565,7 @@ static struct platform_driver mid_thermal_driver = {
>  	.id_table = therm_id_table,
>  };
> 
> -static int __init mid_thermal_module_init(void)
> -{
> -	return platform_driver_register(&mid_thermal_driver);
> -}
> -
> -static void __exit mid_thermal_module_exit(void)
> -{
> -	platform_driver_unregister(&mid_thermal_driver);
> -}
> -
> -module_init(mid_thermal_module_init);
> -module_exit(mid_thermal_module_exit);
> +module_platform_driver(mid_thermal_driver);

Thanks,
Durga
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
