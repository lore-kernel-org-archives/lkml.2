Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab0HaG5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:57:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64505 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab0HaG5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:57:14 -0400
Message-ID: <4C7CA7E4.8010005@steinhoff.de>
Date: Tue, 31 Aug 2010 08:57:40 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UIO and Fedora 13  (kernel 33.6)
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com> <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de> <dda83e781002142245l5c95d08bu214a796be289eb22@mail.gmail.com> <dda83e781002142246i61737ae2j4fe7efb660b53d07@mail.gmail.com> <4C7B8CA6.4010504@steinhoff.de> <20100830162435.GB2566@local>
In-Reply-To: <20100830162435.GB2566@local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:/SvKTNsEJmajDq9gLKuMXNGmQjrKyQTZRCWNOriV/XY
 VX/uWQwUwN6PFU6mETzHUrgft5xMUCBA279PuYnhCKe/782yCK
 9reFGER7jU8Wv4HV0k4gH7w1QbBOy2Xpa93VVFyTUKJW3+3BZB
 JXUqjhVjARZfBcQyU21lLPqjnbxr0dCZxMsaS922XC7hJNtegG
 mjxaaLan5VTAnqxJvCqZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hans J. Koch wrote:
> On Mon, Aug 30, 2010 at 12:49:10PM +0200, Armin Steinhoff wrote:
>>   Hi,
>>
>> I'm writing an UIO driver for a plain PC/104 board (ISA bus).
>> After insmod<my_driver_mod>  I don't see an entry of uio0 in /dev
>> and also no entries in /sys/class. There are no error messages at
>> module load.
> Are you sure your probe() function is called?
   That's the case.

>   After a successfull
> uio_register_device() there is both a /dev/uioX and a directory
> /sys/class/uio/uioX/.
   Seems not be possible after a kernel ooops ...
>> The same happens after loading the module uio.ko and uio_pdrv.ko ...
>> no entries at all, no error messages.
>> uio_pdrv needs platform data set up somewhere, did you do that?
>> See docs in Documentation/DocBook/ for more details.

   uio_pdrv.ko was provided unmodified and precompiles by the Fedora 
distro.
   This example seems more or less incomplete ... it seems also the case 
with the uio_pdrv_genirq example

   However, it seems so I have to go back 2 steps and restart after 
reading  more details of the concept of platform devices ...

   Thanks

   --Armin



