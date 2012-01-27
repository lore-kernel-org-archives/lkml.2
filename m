Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2A0Qd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:33:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:2263 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab2A0Qd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:33:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="103410983"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, "mjg@redhat.com" <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/5] platform-x86: intel_mid_thermal: add msic_thermal
 alias
Thread-Topic: [PATCH 3/5] platform-x86: intel_mid_thermal: add msic_thermal
 alias
Thread-Index: AQHM3E+RSn3xbMeVo0qBuGpxj4p5/5YgaYNQ
Date: Fri, 27 Jan 2012 16:33:21 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5902FDDD@BGSMSX101.gar.corp.intel.com>
References: <20120126173729.16719.15431.stgit@bob.linux.org.uk>
 <20120126173912.16719.51752.stgit@bob.linux.org.uk>
In-Reply-To: <20120126173912.16719.51752.stgit@bob.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0RGXWox020513

Hi Alan,

> -----Original Message-----
> From: platform-driver-x86-owner@vger.kernel.org [mailto:platform-driver-x86-
> owner@vger.kernel.org] On Behalf Of Alan Cox
> Sent: Thursday, January 26, 2012 11:09 PM
> To: mjg@redhat.com; platform-driver-x86@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 3/5] platform-x86: intel_mid_thermal: add msic_thermal alias
> 
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> In newer boards this device is called "msic_thermal" instead of
> "msic_sensor". To support both we add suitable alias for the driver.

In all the medfield boards, that we use here, this is named 'msic_thermal'.
So, maybe we should remove msic_sensor and just use msic_thermal.
Or, Do you have any medfield boards that have this entry as 'msic_sensor' ?

Thanks,
Durga

> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/platform/x86/intel_mid_thermal.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/platform/x86/intel_mid_thermal.c
> b/drivers/platform/x86/intel_mid_thermal.c
> index ccd7b1f..de2e62e 100644
> --- a/drivers/platform/x86/intel_mid_thermal.c
> +++ b/drivers/platform/x86/intel_mid_thermal.c
> @@ -550,6 +550,7 @@ static int mid_thermal_remove(struct platform_device *pdev)
> 
>  static const struct platform_device_id therm_id_table[] = {
>  	{ DRIVER_NAME, 1 },
> +	{ "msic_thermal", 1 },
>  	{ }
>  };
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
