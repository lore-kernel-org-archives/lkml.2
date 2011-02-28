Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1B1K5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:57:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50194 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab1B1K5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:57:18 -0500
Date: Mon, 28 Feb 2011 19:57:13 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 09/09] ARM: s3c2440: gta02: Add touchscreen support
In-reply-to: <4D6B7CA5.9010708@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-id: <003501cbd736$43c26410$cb472c30$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvXNVM9IzT3bEiAQYSwqUHX/zqEtAAAJykg
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
 <1297043521-21903-9-git-send-email-lars@metafoo.de>
 <000201cbd70d$4f67f1f0$ee37d5d0$%kim@samsung.com> <4D6B7CA5.9010708@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> On 02/28/2011 07:04 AM, Kukjin Kim wrote:
> > Lars-Peter Clausen wrote:
> >>

(snip)

> >>  /* Buttons */
> >>  static struct gpio_keys_button gta02_buttons[] = {
> >>  	{
> >> @@ -533,6 +542,8 @@ static struct platform_device *gta02_devices[]
> > __initdata
> >> = {
> >>  	&samsung_asoc_dma,
> >>  	&s3c_device_i2c0,
> >>  	&gta02_buttons_device,
> >> +	&s3c_device_adc,
> >
> > No need to build plat-samsung/dev-adc.c for this?
> > If you want to add '&s3c_deivce_adc', should add 'select
SAMSUNG_DEV_ADC'
> > into "config MACH_NEO1973_GTA02".
> 
> There appear to be two different definitions for s3c_deivce_adc one is in
> plat-samsung/dev-adc.c the other is in plat-s3c24xx/devs.c. So if I select
> SAMSUNG_DEV_ADC I'll actually get compile errors.
> The definition in plat-s3c24xx/devs.c should probably be dropped, but
thats
> something for a different patch.
> 
Oops, you're right...ok, please keep your current code.
If required, we can do it later :)

(snip)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

