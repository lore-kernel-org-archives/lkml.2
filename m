Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815Ab0HLQZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:25:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49474 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab0HLQZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=etiYmVESFMXAdzeZ6BFaQYdqNhFJANM/7dJYiDFWm+N8z9fjUHQ/UvA8vJS2g2fQ0/
         oe4DNtd5JAfKhvoFFRPfSUiCUVd2Xctvebaa1ejzVfi9/Fcy49kUu5n34/jO4cL7BOTC
         jUsXzeJSc3BExQKMuwLaA1G1C5Mm/uvDNIgXw=
MIME-Version: 1.0
In-Reply-To: <4C641D56.9000309@oracle.com>
References: <AANLkTimGwbP8_fachx9pwTyX1wZxxT1iGrKziWMmxunL@mail.gmail.com>
 <20100811165403.6713d206.randy.dunlap@oracle.com> <AANLkTi=D+ZAkg1PYHH-t4u4LFFoY9zOX+DpA_xMU=bY=@mail.gmail.com>
 <AANLkTimkYhwVy3XdMvBb9oqVVOFb9MSjivrMfgM+B7_w@mail.gmail.com> <4C641D56.9000309@oracle.com>
From: Pistis Valentino <vale.pistis@gmail.com>
Date: Thu, 12 Aug 2010 18:25:13 +0200
Message-ID: <AANLkTimWb9uXxdbfusDLcPqA60_VVz-V264_-3CWJ4HW@mail.gmail.com>
Subject: Re: Problems Compile Misc Module Example
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/12 Randy Dunlap <randy.dunlap@oracle.com>:
> On 08/12/10 09:09, Pistis Valentino wrote:
>> Hello,
>>
>> to be fair, I write how I solved my problem:
>>
>> i have 2 files driver_ase.c and driver_ase.h.
>>
>> Inside a .h file there was some declarations includes for kernel
>> headers used only by driver_ase.c.
>> This includes declarations make a problems during compile the service_ase.c.
>>
>> In other words the problem is not in the kernel, but is my C (header)
>> kow-how  problem.
>
> Glad to hear that you have solved this.
>
>> Sorry
>>
>> Ciao
>> Vale
>>
>> P.S. Make and Compile the kernel modules it's very hard! lacks a
>> coherent and updated documentation for non-experts.
>>
>
> Well, we try, but if you would like to add some documentation on it,
> please send it.
>

Your work is precious and very great!
Thank you so much!

Within a few days will send a brief documentation on my work-example
and the precautions I had taken.
So who has never written a sample driver from scratch will avoid the
problems I found.

Show me where it is ok to send the doc on this mailing list.

>>
>> 2010/8/12 Pistis Valentino <vale.pistis@gmail.com>:
>>> Yes i used this Makefile for compiling a module (and no errors),
>>> but the problem is in the compiling the service_ase.
>>>
>>> The section 2 of Documentation describe the same makefile that i use.
>>>
>>> I do not know what else to do
>>>
>>> ============== Makefile ================
>>>
>>> obj-m := driver_ase.o
>>>
>>> KDIR    := /lib/modules/$(shell uname -r)/build
>>> PWD     := $(shell pwd)
>>>
>>> all:
>>>        $(MAKE) -C $(KDIR) M=$(PWD) modules
>>>
>>> clean:
>>>        $(MAKE) -C $(KDIR) M=$(PWD) clean
>>> ===========================================
>>>
>>>
>>>
>>> 2010/8/12 Randy Dunlap <randy.dunlap@oracle.com>:
>>>> On Thu, 12 Aug 2010 01:46:27 +0200 Pistis Valentino wrote:
>>>>
>>>>> Hello everyone,
>>>>>
>>>>> I'm studying how to build kernel modules.
>>>>> Right now I have found some strange errors and nothing solutions in the web.
>>>>>
>>>>> I compiled my kernel module "driver_ase" whose files are driver_ase.h,
>>>>> driver_ase.c.
>>>>> No errors in compilation, the module is also loaded correctly.
>>>>>
>>>>> I wrote a small service "service_ase.c" using the kernel module that I created.
>>>>> I found a lot of errors.
>>>>> the only explanation IMO is that the directory has been renamed  from
>>>>> "/usr/src/linux-2.6.34.2/include/asm" in
>>>>> "/usr/src/linux-2.6.34.2/include/asm-generic", the errors make me
>>>>> think that some header file has not yet updated.
>>>>>
>>>>> You may like this or something wrong?
>>>>>
>>>>> Could you help me please?
>>>>>
>>>>> I'm using Debian Sidux with 2.6.34.2 kernel compiled.
>>>>>
>>>>> In the bottom of the mail has the source codes, and the error.
>>>>> It is a bit long error message, sorry!
>>>>
>>>> You need a minimal Makefile.
>>>> Please see Documentation/kbuild/modules.txt, section 2. How to build external modules.
>>>>
>>>>
>>>> ---
>>>> ~Randy
>>>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>>>
>>>
>
>
> --
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
