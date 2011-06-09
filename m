Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1FISo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:44:59 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:11185 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1FISo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:44:58 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1307645097!25266538!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Date: Thu, 9 Jun 2011 13:44:54 -0500
Subject: RE: [PATCH] gpio-ep93xx: convert to platform_driver and use
 basic_mmio_gpio library
Thread-Topic: [PATCH] gpio-ep93xx: convert to platform_driver and use
 basic_mmio_gpio library
Thread-Index: Acwm1QG5PQ+QECUYSbuMx56GVdyDtgAADA1g
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3820B8578@AUSP01VMBX24.collaborationhost.net>
References: <201106081435.33578.hartleys@visionengravers.com>
 <20110608220757.GB17138@ponder.secretlab.ca>
 <ADE657CA350FB648AAC2C43247A983F001F3820B84D3@AUSP01VMBX24.collaborationhost.net>
 <BANLkTim1_6LZ1u_p-uhf5dYQYuKTjSSqZQ@mail.gmail.com>
In-Reply-To: <BANLkTim1_6LZ1u_p-uhf5dYQYuKTjSSqZQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 09, 2011 11:42 AM, Grant Likely wrote:
> On Thu, Jun 9, 2011 at 10:43 AM, H Hartley Sweeten wrote:
>> On Wednesday, June 08, 2011 3:08 PM, Grant Likely wrote:
>>>
>>> Merged, thanks.
>>
>> Thanks.  I just noticed I left in a debug message I added when changing
>> this to a platform_driver.
>>
>>>> +static int __init ep93xx_gpio_init(void)
>>>> +{
>>>> +    pr_info("%s\n", __func__);
>>>> +    return platform_driver_register(&ep93xx_gpio_driver);
>>>>  }
>>
>> That pr_info shouldn't be there.  It just adds noise.
>>
>> Would you prefer a full new patch or just an incremental patch to remove
>> this line?  The patch is already in next-20110609.
>>
>> Thanks, sorry for the trouble
>
> Neither.  I just fixed it up and pushed out a commit.

Thanks!

Regards,
Hartley