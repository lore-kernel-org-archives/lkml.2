Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab1LKJY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 04:24:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:55867 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1LKJY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 04:24:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="84464478"
Message-ID: <4EE476D9.2040701@linux.intel.com>
Date: Sun, 11 Dec 2011 01:24:41 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: gimli <gimli@dark-green.com>
CC: "lkml, " <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [PATCH] efifb: Update documentation to include generic EFI 1.1
 and UEFI 2.0 platforms
References: <4EE112A8.5030006@linux.intel.com> <4EE3B5AD.6060505@dark-green.com>
In-Reply-To: <4EE3B5AD.6060505@dark-green.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/10/2011 11:40 AM, gimli wrote:
> On 2011-12-08 20:40, Darren Hart wrote:
>> According to the Kconfig help, efifb supports EFI 1.1 and UEFI 2.0 platforms
>> in addition to the Intel based Macs. I have Atom development platforms that
>> require CONFIG_FB_EFI for kernel output to the display console. I have left
>> the Mac kernel parameters alone as I do not have hardware to test it.
>>
>> Signed-off-by: Darren Hart<dvhart@linux.intel.com>
>> CC: H. Peter Anvin<hpa@zytor.com>
>> CC: Matt Fleming<matt.fleming@linux.intel.com>
>> CC: Edgar Hucek<gimli@dark-green.com>
>> ---
>>   Documentation/fb/efifb.txt |   12 ++++++++----
>>   1 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/fb/efifb.txt b/Documentation/fb/efifb.txt
>> index a59916c..7cb9a62 100644
>> --- a/Documentation/fb/efifb.txt
>> +++ b/Documentation/fb/efifb.txt
>> @@ -2,12 +2,15 @@
>>   What is efifb?
>>   ===============
>>
>> -This is a generic EFI platform driver for Intel based Apple computers.
>> -efifb is only for EFI booted Intel Macs.
>> +This is a generic EFI platform driver for Intel based Apple computers and
>> +platforms with EFI 1.10 or UEFI 2.0 firmware. Select CONFIG_FB_EFI to add
>> +support for using the EFI framebuffer as your console.
>>
>>   Supported Hardware
>>   ==================
>>
>> +EFI 1.10 platforms
>> +UEFI 2.0 platforms
>>   iMac 17"/20"
>>   Macbook
>>   Macbook Pro 15"/17"
>> @@ -16,8 +19,9 @@ MacMini
>>   How to use it?
>>   ==============
>>
>> -efifb does not have any kind of autodetection of your machine.
>> -You have to add the following kernel parameters in your elilo.conf:
>> +efifb will autodetect the framebuffer on some machines, for others
>> +you will have to add the appropriate kernel parameters to your boot
>> +loader configuration. For example:
>>   	Macbook :
>>   		video=efifb:macbook
>>   	MacMini :
> 
> Looks ok to me :
> 
> Acked-by: Edgar Hucek <gimli@dark-green.com>
> 
> Please forward it to the LKML.

Sorry, what do you mean? The original did go to lkml, as did all
replies, including yours...

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
