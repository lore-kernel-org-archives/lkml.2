Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1FISmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:42:37 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61915 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab1FISmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:42:36 -0400
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3820B84D3@AUSP01VMBX24.collaborationhost.net>
References: <201106081435.33578.hartleys@visionengravers.com>
 <20110608220757.GB17138@ponder.secretlab.ca> <ADE657CA350FB648AAC2C43247A983F001F3820B84D3@AUSP01VMBX24.collaborationhost.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 9 Jun 2011 12:42:16 -0600
X-Google-Sender-Auth: OslebZqWdaEj9l2_1fMYFCEnMxE
Message-ID: <BANLkTim1_6LZ1u_p-uhf5dYQYuKTjSSqZQ@mail.gmail.com>
Subject: Re: [PATCH] gpio-ep93xx: convert to platform_driver and use
 basic_mmio_gpio library
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 10:43 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> On Wednesday, June 08, 2011 3:08 PM, Grant Likely wrote:
>>
>> Merged, thanks.
>
> Thanks.  I just noticed I left in a debug message I added when changing
> this to a platform_driver.
>
>>> +static int __init ep93xx_gpio_init(void)
>>> +{
>>> +    pr_info("%s\n", __func__);
>>> +    return platform_driver_register(&ep93xx_gpio_driver);
>>>  }
>
> That pr_info shouldn't be there.  It just adds noise.
>
> Would you prefer a full new patch or just an incremental patch to remove
> this line?  The patch is already in next-20110609.
>
> Thanks, sorry for the trouble

Neither.  I just fixed it up and pushed out a commit.

g.



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
