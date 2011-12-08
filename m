Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab1LHUhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:37:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab1LHUhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:37:20 -0500
Message-ID: <4EE11FEF.2060003@redhat.com>
Date: Thu, 08 Dec 2011 15:37:03 -0500
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Darren Hart <dvhart@linux.intel.com>,
        "lkml," <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Edgar Hucek <gimli@dark-green.com>
Subject: Re: [PATCH] efifb: Update documentation to include generic EFI 1.1
 and UEFI 2.0 platforms
References: <4EE112A8.5030006@linux.intel.com> <1323374061.3894.81.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1323374061.3894.81.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 02:54 PM, Matt Fleming wrote:
> (Adding Peter Jones, the efifb maintainer)
>
> On Thu, 2011-12-08 at 11:40 -0800, Darren Hart wrote:
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
>> --
>> 1.7.6.4
>
> Looks good to me,
>
> Acked-by: Matt Fleming<matt.fleming@intel.com>

Likewise:

Acked-by: Peter Jones <pjones@redhat.com>


-- 
         Peter

Space, is big. Really big. You just won't believe how vastly hugely
mindbogglingly big it is. I mean you may think it's a long way down the
road to the chemist, but that's just peanuts to space.
		-- The Hitchhiker's Guide to the Galaxy

01234567890123456789012345678901234567890123456789012345678901234567890123456789
