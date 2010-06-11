Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0FKOId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 10:08:33 -0400
Received: from mail.tpi.com ([70.99.223.143]:3655 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab0FKOIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 10:08:31 -0400
Message-ID: <4C124358.8020007@canonical.com>
Date: Fri, 11 Jun 2010 08:08:24 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Islam Amer <pharon@gmail.com>
CC: Rezwanul_Kabir@dell.com, mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Dell Studio 1555 eject key does not work ( small patch to fix
 	included )
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com> 	<20100602213429.GA14866@srcf.ucam.org> <57DF5FDC2DC0634FA2A310BC5B81A68D01DF4CD01E@AUSX7MCPC108.AMER.DELL.COM> 	<AANLkTimIl6UL0HQT1wxRgXuj_m0O3CwMHQIa1xNE1Ax9@mail.gmail.com> 	<AANLkTin0qht1XR2rUgIXMEeJNU_gb3IZWqSBJb7NXD8K@mail.gmail.com> 	<57DF5FDC2DC0634FA2A310BC5B81A68D01DFD57663@AUSX7MCPC108.AMER.DELL.COM> 	<20100610184023.GA17320@srcf.ucam.org> <AANLkTilT3KCeJUpG-APK0MFh2ChMlZ4qwVPhOJpHnPB9@mail.gmail.com> 	<57DF5FDC2DC0634FA2A310BC5B81A68D01DFD5780A@AUSX7MCPC108.AMER.DELL.COM> <AANLkTinoWK4uSL2KOhgF-EVWuBhgCeAqWwL9cJKeGRD1@mail.gmail.com>
In-Reply-To: <AANLkTinoWK4uSL2KOhgF-EVWuBhgCeAqWwL9cJKeGRD1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Islam Amer,

You could try a vanilla stable kernel from 
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.32.15.5-lucid/ to see 
if we've borked the dell-wmi code.

rtg

On 06/11/2010 07:28 AM, Islam Amer wrote:
> Rezwanul,
>
> I've updated my bios to A11 and installed a new unmodified kernel. The
> issue still persists that the eject key produces "dell-wmi: Unknown
> key 0 pressed" in the dmesg output and it doesn't work.
>
> It is possible that Ubuntu is including patches to fix stuff. The
> latest patch for the Lucid kernel at
> http://archive.ubuntu.com/ubuntu/pool/main/l/linux/linux_2.6.32-22.36.diff.gz
> does include patches that touch wmi and dell-wmi code, but I can't
> find a specific change that would fix this issue.
>
> I might try to selectively apply patches from it and see if it gets fixed.
>
> Thanks.
>
>
> On Fri, Jun 11, 2010 at 3:15 AM,<Rezwanul_Kabir@dell.com>  wrote:
>> Islam Amer
>>
>>    Please try the new BIOS A11 and eliminate any potential BIOS issues. The BIOS team confirmed that
>>    they weren't able to reproduce the issue with Ubuntu 10.04 and A11.
>>
>> Thanks..
>>    --rez
>>
>>
>>
>>
>> Rezwanul Kabir
>> Dell Linux Development
>> 512-725-0766
>>
>>
>>> -----Original Message-----
>>> From: Islam Amer [mailto:pharon@gmail.com]
>>> Sent: Thursday, June 10, 2010 6:52 PM
>>> To: Matthew Garrett
>>> Cc: Kabir, Rezwanul; linux-kernel@vger.kernel.org;
>>> platform-driver-x86@vger.kernel.org; akpm@linux-foundation.org
>>> Subject: Re: Dell Studio 1555 eject key does not work ( small
>>> patch to fix included )
>>>
>>> Hello all,
>>>
>>> My bios version is A08 , I see that A11 was recently released
>>> but the changelog doesn't say much.
>>>
>>> Which is better, upgrade and hope the problem goes away, or
>>> wait until we have a fix that is agreed upon ?
>>>
>>> Thanks.
>>>
>>> On Thu, Jun 10, 2010 at 9:40 PM, Matthew Garrett
>>> <mjg59@srcf.ucam.org>  wrote:
>>>> On Thu, Jun 10, 2010 at 01:36:56PM -0500,
>>> Rezwanul_Kabir@Dell.com wrote:
>>>>> Hi Islam Amer
>>>>>
>>>>>     I got report that "Ubuntu 10.04 + BIOS A11" was tested and the
>>>>> "Eject CD" key is working
>>>>>     as expected. Sorry, I couldn't find any Studio 1555 to
>>> test myself
>>>>> and cannot provide you
>>>>>     with more details.
>>>>>
>>>>>      Also, you may try acpi_osi="Windows 2009" kernel
>>> parameter and see if there is any difference.
>>>>
>>>> That's the default on any kernel that has this support in dell-wmi.
>>>> Rez, could you let me know if the proposed patch breaks the spec in
>>>> ways that are likely to cause problems?
>>>>
>>>> --
>>>> Matthew Garrett | mjg59@srcf.ucam.org
>>>>
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Tim Gardner tim.gardner@canonical.com
