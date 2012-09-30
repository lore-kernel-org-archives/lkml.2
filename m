Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab2I3EIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 00:08:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58195 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2I3EID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 00:08:03 -0400
Subject: Re: [PATCH] extcon: adc-jack: Add missing MODULE_LICENSE
From: anish kumar <anish198519851985@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        anish kumar <anish.singh@samsung.com>
In-Reply-To: <1348792430.11539.2.camel@phoenix>
References: <1348792430.11539.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Sep 2012 09:37:55 +0530
Message-ID: <1348978075.7492.1.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 08:33 +0800, Axel Lin wrote:
> This driver can be built as a module, add MODULE_LICENSE for it.
> For completeness, also adds MODULE_AUTHOR and MODULE_DESCRIPTION.
Aha I forgot that.Good one.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/extcon/extcon-adc-jack.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
> index 2cc6bec..e87196f 100644
> --- a/drivers/extcon/extcon-adc-jack.c
> +++ b/drivers/extcon/extcon-adc-jack.c
> @@ -14,6 +14,7 @@
>   *
>   */
>  
> +#include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/device.h>
>  #include <linux/platform_device.h>
> @@ -195,3 +196,7 @@ static struct platform_driver adc_jack_driver = {
>  };
>  
>  module_platform_driver(adc_jack_driver);
> +
> +MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
> +MODULE_DESCRIPTION("ADC Jack extcon driver");
> +MODULE_LICENSE("GPL v2");


