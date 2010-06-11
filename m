Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab0FKAP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:15:57 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:8227 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab0FKAPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:15:55 -0400
X-Loopcount0: from 10.166.62.177
From: <Rezwanul_Kabir@Dell.com>
To: <pharon@gmail.com>, <mjg59@srcf.ucam.org>
CC: <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>,
       <akpm@linux-foundation.org>
Date: Thu, 10 Jun 2010 19:15:47 -0500
Subject: RE: Dell Studio 1555 eject key does not work ( small patch to fix
 	included )
Thread-Topic: Dell Studio 1555 eject key does not work ( small patch to fix
 	included )
Thread-Index: AcsI+F8+hKX8fogNRoaA0KefXAuQFgAACWhg
Message-ID: <57DF5FDC2DC0634FA2A310BC5B81A68D01DFD5780A@AUSX7MCPC108.AMER.DELL.COM>
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com>
 	<20100602213429.GA14866@srcf.ucam.org>
 <57DF5FDC2DC0634FA2A310BC5B81A68D01DF4CD01E@AUSX7MCPC108.AMER.DELL.COM>
 	<AANLkTimIl6UL0HQT1wxRgXuj_m0O3CwMHQIa1xNE1Ax9@mail.gmail.com>
 	<AANLkTin0qht1XR2rUgIXMEeJNU_gb3IZWqSBJb7NXD8K@mail.gmail.com>
 	<57DF5FDC2DC0634FA2A310BC5B81A68D01DFD57663@AUSX7MCPC108.AMER.DELL.COM>
 	<20100610184023.GA17320@srcf.ucam.org>
 <AANLkTilT3KCeJUpG-APK0MFh2ChMlZ4qwVPhOJpHnPB9@mail.gmail.com>
In-Reply-To: <AANLkTilT3KCeJUpG-APK0MFh2ChMlZ4qwVPhOJpHnPB9@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Jun 2010 00:15:49.0578 (UTC) FILETIME=[3EEDDAA0:01CB08FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Islam Amer

   Please try the new BIOS A11 and eliminate any potential BIOS issues. The BIOS team confirmed that
   they weren't able to reproduce the issue with Ubuntu 10.04 and A11.

Thanks..
   --rez




Rezwanul Kabir
Dell Linux Development
512-725-0766
 

>-----Original Message-----
>From: Islam Amer [mailto:pharon@gmail.com] 
>Sent: Thursday, June 10, 2010 6:52 PM
>To: Matthew Garrett
>Cc: Kabir, Rezwanul; linux-kernel@vger.kernel.org; 
>platform-driver-x86@vger.kernel.org; akpm@linux-foundation.org
>Subject: Re: Dell Studio 1555 eject key does not work ( small 
>patch to fix included )
>
>Hello all,
>
>My bios version is A08 , I see that A11 was recently released 
>but the changelog doesn't say much.
>
>Which is better, upgrade and hope the problem goes away, or 
>wait until we have a fix that is agreed upon ?
>
>Thanks.
>
>On Thu, Jun 10, 2010 at 9:40 PM, Matthew Garrett 
><mjg59@srcf.ucam.org> wrote:
>> On Thu, Jun 10, 2010 at 01:36:56PM -0500, 
>Rezwanul_Kabir@Dell.com wrote:
>>> Hi Islam Amer
>>>
>>>    I got report that "Ubuntu 10.04 + BIOS A11" was tested and the 
>>> "Eject CD" key is working
>>>    as expected. Sorry, I couldn't find any Studio 1555 to 
>test myself 
>>> and cannot provide you
>>>    with more details.
>>>
>>>     Also, you may try acpi_osi="Windows 2009" kernel 
>parameter and see if there is any difference.
>>
>> That's the default on any kernel that has this support in dell-wmi. 
>> Rez, could you let me know if the proposed patch breaks the spec in 
>> ways that are likely to cause problems?
>>
>> --
>> Matthew Garrett | mjg59@srcf.ucam.org
>>
>