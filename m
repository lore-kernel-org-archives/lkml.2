Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1FIQnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:43:14 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:13504 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1FIQnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:43:09 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1307637787!7431340!4
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Date: Thu, 9 Jun 2011 11:43:05 -0500
Subject: RE: [PATCH] gpio-ep93xx: convert to platform_driver and use
 basic_mmio_gpio library
Thread-Topic: [PATCH] gpio-ep93xx: convert to platform_driver and use
 basic_mmio_gpio library
Thread-Index: AcwmKIjtRvfu50i2TL+BacEkv3cMdQAm0sMg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3820B84D3@AUSP01VMBX24.collaborationhost.net>
References: <201106081435.33578.hartleys@visionengravers.com>
 <20110608220757.GB17138@ponder.secretlab.ca>
In-Reply-To: <20110608220757.GB17138@ponder.secretlab.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 08, 2011 3:08 PM, Grant Likely wrote:
>
> Merged, thanks.

Thanks.  I just noticed I left in a debug message I added when changing
this to a platform_driver.

>> +static int __init ep93xx_gpio_init(void)
>> +{
>> +	pr_info("%s\n", __func__);
>> +	return platform_driver_register(&ep93xx_gpio_driver);
>>  }

That pr_info shouldn't be there.  It just adds noise.

Would you prefer a full new patch or just an incremental patch to remove
this line?  The patch is already in next-20110609.

Thanks, sorry for the trouble.

Regards,
Hartley