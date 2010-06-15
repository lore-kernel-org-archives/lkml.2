Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab0FORYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:24:10 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:1431 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab0FORYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:24:08 -0400
X-Loopcount0: from 10.166.72.158
From: <Rezwanul_Kabir@Dell.com>
To: <pharon@gmail.com>, <tim.gardner@canonical.com>
CC: <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <platform-driver-x86@vger.kernel.org>, <akpm@linux-foundation.org>
Date: Tue, 15 Jun 2010 12:23:57 -0500
Subject: RE: Dell Studio 1555 eject key does not work ( small patch to fix
 	included )
Thread-Topic: Dell Studio 1555 eject key does not work ( small patch to fix
 	included )
Thread-Index: AcsJzl2u51JcuR6SQDisjwtSg5RikwC39sJQ
Message-ID: <57DF5FDC2DC0634FA2A310BC5B81A68D01E06306A9@AUSX7MCPC108.AMER.DELL.COM>
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com>
 	<20100602213429.GA14866@srcf.ucam.org>
 <57DF5FDC2DC0634FA2A310BC5B81A68D01DF4CD01E@AUSX7MCPC108.AMER.DELL.COM>
 	<AANLkTimIl6UL0HQT1wxRgXuj_m0O3CwMHQIa1xNE1Ax9@mail.gmail.com>
 	<AANLkTin0qht1XR2rUgIXMEeJNU_gb3IZWqSBJb7NXD8K@mail.gmail.com>
 	<57DF5FDC2DC0634FA2A310BC5B81A68D01DFD57663@AUSX7MCPC108.AMER.DELL.COM>
 	<20100610184023.GA17320@srcf.ucam.org>
 <AANLkTilT3KCeJUpG-APK0MFh2ChMlZ4qwVPhOJpHnPB9@mail.gmail.com>
 	<57DF5FDC2DC0634FA2A310BC5B81A68D01DFD5780A@AUSX7MCPC108.AMER.DELL.COM>
 	<AANLkTinoWK4uSL2KOhgF-EVWuBhgCeAqWwL9cJKeGRD1@mail.gmail.com>
 	<4C124358.8020007@canonical.com>
 <AANLkTimxo3CeRR2YZptTL6RoEi8Q5sdnUEMIi9A5-KcA@mail.gmail.com>
 	<AANLkTilaoFJuT8d9iPWqDzyxBC8o4E1Vhh03ufiwLEk-@mail.gmail.com>
 	<4C128201.8020104@canonical.com>
 <AANLkTin1bEjYt08P923v1c0aSM1O6kYDwoaOYiFufGCd@mail.gmail.com>
In-Reply-To: <AANLkTin1bEjYt08P923v1c0aSM1O6kYDwoaOYiFufGCd@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 15 Jun 2010 17:23:59.0532 (UTC) FILETIME=[8AA8CEC0:01CB0CAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew/Islam

   I don't know how Ubuntu 10.04 fixed the issue, but from my communications with the BIOS team, I think 
 Islam's patch would be acceptable. "buffer_entry[1] == 0x0" would indicate HotKey events on these platforms.

Thanks..
   --rez

 

Rezwanul Kabir
Dell Linux Development
512-725-0766
 

>-----Original Message-----
>From: Islam Amer [mailto:pharon@gmail.com] 
>Sent: Friday, June 11, 2010 8:27 PM
>To: tim.gardner@canonical.com
>Cc: Kabir, Rezwanul; mjg59@srcf.ucam.org; 
>linux-kernel@vger.kernel.org; 
>platform-driver-x86@vger.kernel.org; akpm@linux-foundation.org
>Subject: Re: Dell Studio 1555 eject key does not work ( small 
>patch to fix included )
>
>What would you like me to do now? I want to help :)
>
>Thanks.
>
>On Fri, Jun 11, 2010 at 9:35 PM, Tim Gardner 
><tim.gardner@canonical.com> wrote:
>> The only difference between 2.6.32.15 and Ubuntu Lucid wrt 
>dell-wmi.c 
>> is
>> this:
>>
>> 43,46d42
>> < /* Temporary workaround until the WMI sysfs interface goes in.
>> <    Borrowed from acer-wmi */
>> < MODULE_ALIAS("dmi:*:*Dell*:*:");
>> <
>>
>> I wonder about input event filtering? There are substantial 
>> differences in drivers/input/input.c.
>>
>> rtg
>>
>> On 06/11/2010 12:02 PM, Islam Amer wrote:
>>>
>>> Dear Tim,
>>>
>>> I tried the mainline kernel 2.6.32-0206321505-generic as you 
>>> suggested and the eject key doesn't work but it also 
>doesn't produce 
>>> the error message in dmesg.
>>>
>>> I then tried the 2.6.32-22.36-generic from 
>>> 
>http://packages.ubuntu.com/lucid/linux-image-2.6.32-22-generic and I 
>>> found the eject key working fine.
>>>
>>> So there is something in the ubuntu patchset that fixes this issue.
>>>
>>> On Fri, Jun 11, 2010 at 5:23 PM, Islam 
>Amer<pharon@gmail.com>  wrote:
>>>>
>>>> Tim I am running debian,
>>>>
>>>> I think it's the other way round, the mainline kernel is borked ( 
>>>> regarding dell-wmi and eject key ) while the lucid patched kernel 
>>>> works ( as reported by dell team ).
>>>>
>>>> I guess I could download a Lucid livecd and see if the eject key 
>>>> works there ( event only as it won't eject the lived while it is 
>>>> running :)
>>>> )
>>>>
>>>> On Fri, Jun 11, 2010 at 5:08 PM, Tim 
>>>> Gardner<tim.gardner@canonical.com>
>>>>  wrote:
>>>>>
>>>>> Islam Amer,
>>>>>
>>>>> You could try a vanilla stable kernel from 
>>>>> http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.32.15.5-lucid/ 
>>>>> to see if we've borked the dell-wmi code.
>>>>>
>>>>> rtg
>>>>>
>>>>> On 06/11/2010 07:28 AM, Islam Amer wrote:
>>>>>>
>>>>>> Rezwanul,
>>>>>>
>>>>>> I've updated my bios to A11 and installed a new 
>unmodified kernel. 
>>>>>> The issue still persists that the eject key produces "dell-wmi: 
>>>>>> Unknown key 0 pressed" in the dmesg output and it doesn't work.
>>>>>>
>>>>>> It is possible that Ubuntu is including patches to fix 
>stuff. The 
>>>>>> latest patch for the Lucid kernel at
>>>>>>
>>>>>>
>>>>>> 
>http://archive.ubuntu.com/ubuntu/pool/main/l/linux/linux_2.6.32-22
>>>>>> .36.diff.gz does include patches that touch wmi and 
>dell-wmi code, 
>>>>>> but I can't find a specific change that would fix this issue.
>>>>>>
>>>>>> I might try to selectively apply patches from it and see if it 
>>>>>> gets fixed.
>>>>>>
>>>>>> Thanks.
>>>>>>
>>>>>>
>>>>>> On Fri, Jun 11, 2010 at 3:15 
>AM,<Rezwanul_Kabir@dell.com>    wrote:
>>>>>>>
>>>>>>> Islam Amer
>>>>>>>
>>>>>>>   Please try the new BIOS A11 and eliminate any 
>potential BIOS issues.
>>>>>>> The BIOS team confirmed that
>>>>>>>   they weren't able to reproduce the issue with Ubuntu 
>10.04 and A11.
>>>>>>>
>>>>>>> Thanks..
>>>>>>>   --rez
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Rezwanul Kabir
>>>>>>> Dell Linux Development
>>>>>>> 512-725-0766
>>>>>>>
>>>>>>>
>>>>>>>> -----Original Message-----
>>>>>>>> From: Islam Amer [mailto:pharon@gmail.com]
>>>>>>>> Sent: Thursday, June 10, 2010 6:52 PM
>>>>>>>> To: Matthew Garrett
>>>>>>>> Cc: Kabir, Rezwanul; linux-kernel@vger.kernel.org; 
>>>>>>>> platform-driver-x86@vger.kernel.org; akpm@linux-foundation.org
>>>>>>>> Subject: Re: Dell Studio 1555 eject key does not work ( small 
>>>>>>>> patch to fix included )
>>>>>>>>
>>>>>>>> Hello all,
>>>>>>>>
>>>>>>>> My bios version is A08 , I see that A11 was recently released 
>>>>>>>> but the changelog doesn't say much.
>>>>>>>>
>>>>>>>> Which is better, upgrade and hope the problem goes 
>away, or wait 
>>>>>>>> until we have a fix that is agreed upon ?
>>>>>>>>
>>>>>>>> Thanks.
>>>>>>>>
>>>>>>>> On Thu, Jun 10, 2010 at 9:40 PM, Matthew Garrett 
>>>>>>>> <mjg59@srcf.ucam.org>    wrote:
>>>>>>>>>
>>>>>>>>> On Thu, Jun 10, 2010 at 01:36:56PM -0500,
>>>>>>>>
>>>>>>>> Rezwanul_Kabir@Dell.com wrote:
>>>>>>>>>>
>>>>>>>>>> Hi Islam Amer
>>>>>>>>>>
>>>>>>>>>>    I got report that "Ubuntu 10.04 + BIOS A11" was 
>tested and 
>>>>>>>>>> the "Eject CD" key is working
>>>>>>>>>>    as expected. Sorry, I couldn't find any Studio 1555 to
>>>>>>>>
>>>>>>>> test myself
>>>>>>>>>>
>>>>>>>>>> and cannot provide you
>>>>>>>>>>    with more details.
>>>>>>>>>>
>>>>>>>>>>     Also, you may try acpi_osi="Windows 2009" kernel
>>>>>>>>
>>>>>>>> parameter and see if there is any difference.
>>>>>>>>>
>>>>>>>>> That's the default on any kernel that has this 
>support in dell-wmi.
>>>>>>>>> Rez, could you let me know if the proposed patch breaks the 
>>>>>>>>> spec in ways that are likely to cause problems?
>>>>>>>>>
>>>>>>>>> --
>>>>>>>>> Matthew Garrett | mjg59@srcf.ucam.org
>>>>>>>>>
>>>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line 
>"unsubscribe linux-kernel"
>>>>>> in
>>>>>> the body of a message to majordomo@vger.kernel.org More 
>majordomo 
>>>>>> info at  http://vger.kernel.org/majordomo-info.html
>>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>
>>>>>
>>>>> --
>>>>> Tim Gardner tim.gardner@canonical.com
>>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-kernel" in the body of a message to majordomo@vger.kernel.org 
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>> --
>> Tim Gardner tim.gardner@canonical.com
>>
>