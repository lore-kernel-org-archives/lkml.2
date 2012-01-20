Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2ATVxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 16:53:44 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:52451 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753832Ab2ATVxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 16:53:43 -0500
Message-ID: <4F19E262.6060507@exemail.com.au>
Date: Sat, 21 Jan 2012 08:53:38 +1100
From: Padfoot <padfoot@exemail.com.au>
Reply-To: padfoot@exemail.com.au
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Kernel version 3.2.1 usb touchscreen device not recognised
 [UDEV? USBINPUT? HOOK]
References: <4F192242.1070909@exemail.com.au> <20120120160210.GA21565@kroah.com> <4F19CB06.6040801@exemail.com.au> <20120120204444.GA20799@kroah.com>
In-Reply-To: <20120120204444.GA20799@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/12 07:44, Greg KH wrote:
> On Sat, Jan 21, 2012 at 07:13:58AM +1100, Padfoot wrote:
>> On 21/01/12 03:02, Greg KH wrote:
>>> On Fri, Jan 20, 2012 at 07:13:54PM +1100, Padfoot wrote:
>>>> Upgrade from kernel 3.1.9 to 3.2.1 eGalax usb touchscreen device is
>>>> no longer recognised.
>>>>
>>>> Device is an Acer Iconia Tab w501 with inbuilt touchscreen. Screen
>>>> is a pci device but is connected on boot as a usb input device.
>>>> Issue appears to be with either UDEV or USBINPUT boot hook failing
>>>> to recognise the device as can be seen in the dmesg.3.2.1
>>>> attachment.
>>>>
>>>> Downgrading to kernel 3.1.9 corrects the issue.
>>> Can you run 'git bisect' between 3.1.0 and 3.2.0 to find the problem
>>> commit here?
>>>
>>> Also, you might want to cc: the linux-input developers, they can help
>>> you out much better than the general list can.
>>>
>>> greg k-h
>>>
>> Hi Greg,
>>
>> I am not a kernel dev, nor have I ever compiled a kernel, so I don't
>> think I am able to help with a git bisect to locate the offending
>> commit. I am just a regular user running pre-compiled packages on my
>> Arch Linux distro. But, of course I am happy to assist wherever I
>> can.
> If you want to build your own kernel, there are lots of instructions on
> how do this online (google for 'linux kernel in a nutshell' for a free
> book about this.)
>
> Otherwise, can you file a bug with the arch linux developers?  They
> might be able to help you out here better as you are using a distro
> kernel.
>
> good luck,
>
> greg k-h
>
Thanks for your assistance Greg. Benjamin in linux-input has provided 
the solution. This can be marked as solved.

Thank you.

