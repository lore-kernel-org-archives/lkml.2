Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab0IBKNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:13:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55430 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab0IBKNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:13:13 -0400
Message-ID: <4C7F78CA.3020506@steinhoff.de>
Date: Thu, 02 Sep 2010 12:13:30 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [UIO]  SMX UIO interface
References: <4C7DFF2C.8070709@steinhoff.de> <ABD0E28F-0839-4C6F-A0BD-999A28A6803A@niasdigital.com>
In-Reply-To: <ABD0E28F-0839-4C6F-A0BD-999A28A6803A@niasdigital.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:2kSZR3apdfi65A0WQzGZxTwyKb3brnqyL6otvcoVech
 K+3/JlkKg1is1VdqZHDojn4rwvexw466v0ectsfcrmREBsmWjt
 KMg7gg+r4e2YyZ50RZb8k3kTLoFMGm6PjoPMK/AV30nUT73/1w
 4SvIScexXz2wUvjbJ5HULMNE4thtPHwnKIYbvuqozJunKkf+9p
 R+v0Wq5DktZpTzy/JU5UQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Ben Nizette wrote:
> On 01/09/2010, at 5:22 PM, Armin Steinhoff wrote:
>
>> Hi Ben,
>>
>> I have a question about the SMX UIO Interface.
>>
>> In the SMX module you are reading the data of the platform resourses:
>>
>>     regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
>>     if (!regs) {
>>         dev_err(&dev->dev, "No memory resource specified\n");
>>         goto out_free;
>>     }
>>
>> But who sets these data initially ?
> Who ever sets up the platform device that will bind to this driver, usually the board code (eg on avr32 arch/avr32/boards/*/setup.c, ARM is somewhere under arch/arm/mach-*/ I think).
>
> The board code would create an array of struct resource with the appropriate memory regions and an IRQ entry, create a struct platform_device with the right content to bind to that driver, set the platform_device .resource field to the previously created array then call platform_device_register() to kick things off.
>

   That means there is additionally an individual driver of the board 
and the UIO interface is just for open up the hardware interfaces ?

   Thanks

--Armin


> 	--Ben.
>
>> Cheers
>>
>> --Armin
>>
>

