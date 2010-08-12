Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab0HLAQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:16:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60938 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267Ab0HLAQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:16:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GPtAmNMIIN4lm0WJ5RhycUPd0kbwNwXKzzLo2B1eJNV6GGvNmz2VNqYVy5ZEg8QM8A
         rdNpjBn+TD6kFLLD6zqXAeOYZyQTfgxjYmXdDdcj6pApYJ4Yi1D8TOZyXccSScabOM8K
         8xsBfh7WuhtRSKQ4YnWYrdV5DLP5cLRThXF9Y=
MIME-Version: 1.0
In-Reply-To: <20100811165403.6713d206.randy.dunlap@oracle.com>
References: <AANLkTimGwbP8_fachx9pwTyX1wZxxT1iGrKziWMmxunL@mail.gmail.com> 
	<20100811165403.6713d206.randy.dunlap@oracle.com>
From: Pistis Valentino <vale.pistis@gmail.com>
Date: Thu, 12 Aug 2010 02:16:32 +0200
Message-ID: <AANLkTi=D+ZAkg1PYHH-t4u4LFFoY9zOX+DpA_xMU=bY=@mail.gmail.com>
Subject: Re: Problems Compile Misc Module Example
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes i used this Makefile for compiling a module (and no errors),
but the problem is in the compiling the service_ase.

The section 2 of Documentation describe the same makefile that i use.

I do not know what else to do

============== Makefile ================

obj-m := driver_ase.o

KDIR    := /lib/modules/$(shell uname -r)/build
PWD     := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
===========================================



2010/8/12 Randy Dunlap <randy.dunlap@oracle.com>:
> On Thu, 12 Aug 2010 01:46:27 +0200 Pistis Valentino wrote:
>
>> Hello everyone,
>>
>> I'm studying how to build kernel modules.
>> Right now I have found some strange errors and nothing solutions in the web.
>>
>> I compiled my kernel module "driver_ase" whose files are driver_ase.h,
>> driver_ase.c.
>> No errors in compilation, the module is also loaded correctly.
>>
>> I wrote a small service "service_ase.c" using the kernel module that I created.
>> I found a lot of errors.
>> the only explanation IMO is that the directory has been renamed  from
>> "/usr/src/linux-2.6.34.2/include/asm" in
>> "/usr/src/linux-2.6.34.2/include/asm-generic", the errors make me
>> think that some header file has not yet updated.
>>
>> You may like this or something wrong?
>>
>> Could you help me please?
>>
>> I'm using Debian Sidux with 2.6.34.2 kernel compiled.
>>
>> In the bottom of the mail has the source codes, and the error.
>> It is a bit long error message, sorry!
>
> You need a minimal Makefile.
> Please see Documentation/kbuild/modules.txt, section 2. How to build external modules.
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
