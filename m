Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1DSIeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:34:17 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36855 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1DSIeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:34:13 -0400
Message-ID: <4DAD48FC.5040003@ahsoftware.de>
Date: Tue, 19 Apr 2011 10:34:04 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Implement /dev/byte (a generic byte source similiar
 to /dev/zero)
References: <1303126676-3456-1-git-send-email-holler@ahsoftware.de> <BANLkTi=yaXOWnUi2s1A-BtoAFgjExX8q4w@mail.gmail.com>
In-Reply-To: <BANLkTi=yaXOWnUi2s1A-BtoAFgjExX8q4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.04.2011 15:57, schrieb Mike Frysinger:
> On Mon, Apr 18, 2011 at 07:37, Alexander Holler wrote:
>> I don't know if this patch qualifies for inclusion into the mainline kernel, but
>> maybe someone else would be interested in such, so I'm posting it here.
>>
>> The main idea for that device was to have a source for 0xff to clear FLASH based
>> devices. And to make it more generic, I've added the possibility to change the
>> default value on a per file descriptor basis.
>>
>> I don't want to discuss if such a device makes sense or if such should be done
>> in userspace only. I like it as a device, otherwise I wouldn't have written it.
>> So besides this message, I will not take part in such a discussion.
>
> cant you do this with cuse ?  that would satisfy the "has to be a
> device" requirement while keeping it in userspace.

I know almost nothing about cuse, but I assume it should be possible to 
build such a device with cuse too.

> although, i have a hard time seeing there be a realistic perf diff with:
> tr '\000' '\377'<  /dev/zero | dd ......

There are many other ways to achieve such in userspace (even without 
using /dev/zero) and I want to avoid such a discussion.

As for /dev/zero there are many other possible reasons to use such a 
device, besides filling something with a value. For me it's as 
reasonable as dev/zero, just that it offers a bit more flexibility and 
provides another, at least for me useful, default value. Maybe 
/dev/nzero would have been a good name too. ;)

But I don't really care about inclusion into the kernel, it's just 
something I had lying around (and needed only marginally work to 
finalize as a proper patch) and I thought someone else could find it 
usefull and I should share that here.

Regards,

Alexander Holler
