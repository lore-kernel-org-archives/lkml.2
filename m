Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab0HLQOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:14:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22100 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933876Ab0HLQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:14:11 -0400
Message-ID: <4C641D56.9000309@oracle.com>
Date: Thu, 12 Aug 2010 09:12:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Pistis Valentino <vale.pistis@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems Compile Misc Module Example
References: <AANLkTimGwbP8_fachx9pwTyX1wZxxT1iGrKziWMmxunL@mail.gmail.com> <20100811165403.6713d206.randy.dunlap@oracle.com> <AANLkTi=D+ZAkg1PYHH-t4u4LFFoY9zOX+DpA_xMU=bY=@mail.gmail.com> <AANLkTimkYhwVy3XdMvBb9oqVVOFb9MSjivrMfgM+B7_w@mail.gmail.com>
In-Reply-To: <AANLkTimkYhwVy3XdMvBb9oqVVOFb9MSjivrMfgM+B7_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/10 09:09, Pistis Valentino wrote:
> Hello,
> 
> to be fair, I write how I solved my problem:
> 
> i have 2 files driver_ase.c and driver_ase.h.
> 
> Inside a .h file there was some declarations includes for kernel
> headers used only by driver_ase.c.
> This includes declarations make a problems during compile the service_ase.c.
> 
> In other words the problem is not in the kernel, but is my C (header)
> kow-how  problem.

Glad to hear that you have solved this.

> Sorry
> 
> Ciao
> Vale
> 
> P.S. Make and Compile the kernel modules it's very hard! lacks a
> coherent and updated documentation for non-experts.
> 

Well, we try, but if you would like to add some documentation on it,
please send it.

> 
> 2010/8/12 Pistis Valentino <vale.pistis@gmail.com>:
>> Yes i used this Makefile for compiling a module (and no errors),
>> but the problem is in the compiling the service_ase.
>>
>> The section 2 of Documentation describe the same makefile that i use.
>>
>> I do not know what else to do
>>
>> ============== Makefile ================
>>
>> obj-m := driver_ase.o
>>
>> KDIR    := /lib/modules/$(shell uname -r)/build
>> PWD     := $(shell pwd)
>>
>> all:
>>        $(MAKE) -C $(KDIR) M=$(PWD) modules
>>
>> clean:
>>        $(MAKE) -C $(KDIR) M=$(PWD) clean
>> ===========================================
>>
>>
>>
>> 2010/8/12 Randy Dunlap <randy.dunlap@oracle.com>:
>>> On Thu, 12 Aug 2010 01:46:27 +0200 Pistis Valentino wrote:
>>>
>>>> Hello everyone,
>>>>
>>>> I'm studying how to build kernel modules.
>>>> Right now I have found some strange errors and nothing solutions in the web.
>>>>
>>>> I compiled my kernel module "driver_ase" whose files are driver_ase.h,
>>>> driver_ase.c.
>>>> No errors in compilation, the module is also loaded correctly.
>>>>
>>>> I wrote a small service "service_ase.c" using the kernel module that I created.
>>>> I found a lot of errors.
>>>> the only explanation IMO is that the directory has been renamed  from
>>>> "/usr/src/linux-2.6.34.2/include/asm" in
>>>> "/usr/src/linux-2.6.34.2/include/asm-generic", the errors make me
>>>> think that some header file has not yet updated.
>>>>
>>>> You may like this or something wrong?
>>>>
>>>> Could you help me please?
>>>>
>>>> I'm using Debian Sidux with 2.6.34.2 kernel compiled.
>>>>
>>>> In the bottom of the mail has the source codes, and the error.
>>>> It is a bit long error message, sorry!
>>>
>>> You need a minimal Makefile.
>>> Please see Documentation/kbuild/modules.txt, section 2. How to build external modules.
>>>
>>>
>>> ---
>>> ~Randy
>>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>>
>>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
