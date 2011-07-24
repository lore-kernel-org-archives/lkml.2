Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1GXNvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 09:51:41 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:59798 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1GXNvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 09:51:36 -0400
Message-ID: <4E2C2362.1080204@monstr.eu>
Date: Sun, 24 Jul 2011 15:51:30 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] input: xilinx_ps2: Add missing of_address.h header
References: <1310564781-5979-1-git-send-email-monstr@monstr.eu> <CACxGe6vRZ4tCALpzFng2y9W_9zB3qQEntma+z292FXzDuYBRKQ@mail.gmail.com>
In-Reply-To: <CACxGe6vRZ4tCALpzFng2y9W_9zB3qQEntma+z292FXzDuYBRKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

can you propose this patch to mainline through your devicetree tree?

Thanks,
Michal

Grant Likely wrote:
> On Wed, Jul 13, 2011 at 10:46 PM, Michal Simek <monstr@monstr.eu> wrote:
>> Add missing header.
>>
>> Error log:
>> CC      drivers/input/serio/xilinx_ps2.o
>> drivers/input/serio/xilinx_ps2.c: In function 'xps2_of_probe':
>> drivers/input/serio/xilinx_ps2.c:249: error: implicit declaration of function 'of_address_to_resource'
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
>> ---
>>  drivers/input/serio/xilinx_ps2.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
>> index 80baa53..d64c5a4 100644
>> --- a/drivers/input/serio/xilinx_ps2.c
>> +++ b/drivers/input/serio/xilinx_ps2.c
>> @@ -23,7 +23,7 @@
>>  #include <linux/init.h>
>>  #include <linux/list.h>
>>  #include <linux/io.h>
>> -
>> +#include <linux/of_address.h>
>>  #include <linux/of_device.h>
>>  #include <linux/of_platform.h>
>>
>> --
>> 1.5.5.6
>>
>>
> 
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
