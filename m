Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab0FVXWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:22:12 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54952 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0FVXWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=oDy94BAPvO+ivUlRWU/TAoAY9qmUbyufQBTCxi7iL9UTSEqmDiPcOO3rIFvh/VkMAF
         lHeahUtRyKkEZXM9WSlbKy7BC1fgffBcXVBjBr+vgZhOkj7QcdOnLiXfp0VIoWAX8/Wf
         fPW3G97AMq+YEE7gRmC1veqgerwokYTGpx4vw=
MIME-Version: 1.0
In-Reply-To: <AANLkTil6E0sA-x9AtIyAU6LGzIi42iyhjITkfVZ2Kxri@mail.gmail.com>
References: <AANLkTil7mInflmvrvVQmOx7xrNVFAY7GtqQiGobHMTT2@mail.gmail.com> 
	<20100621085140.19dda646.randy.dunlap@oracle.com> <AANLkTinQclZGMIcn2VgTH6yd-hUJ_L7Ku7UpuVVBapIG@mail.gmail.com> 
	<4C1FC3EE.8040003@oracle.com> <AANLkTil6E0sA-x9AtIyAU6LGzIi42iyhjITkfVZ2Kxri@mail.gmail.com>
From: Weedy <weedy2887@gmail.com>
Date: Tue, 22 Jun 2010 19:21:49 -0400
Message-ID: <AANLkTikVrqXlSEALYzKMZtQZY9U6IUtr6nmUwGwbyG6T@mail.gmail.com>
Subject: Re: Entropy poolsize
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Man I need to remember to hit reply-to-all

On Mon, Jun 21, 2010 at 3:56 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 06/21/10 12:48, Weedy wrote:
>> On Mon, Jun 21, 2010 at 11:51 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> On Mon, 21 Jun 2010 09:58:16 -0400 Weedy wrote:
>>>
>>>> I know grsecurity has a option for this but I don't want to patch my
>>>> kernel with it at this time. I have been poking around random.c but I
>>>> can't seem to figure out where .poolsize is assigned it's value and
>>>> how to increase it.
>>>>
>>>> If someone could point it out that would be nice.
>>>>
>>>> Thank you for your time.
>>>> --
>>>
>>> Do you mean this one in drivers/char/random.c or something else?
>>>
>>> static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
>>>
>>> It's a sysctl, so it is tunable.
>> It's locked, some kind of security risk many kernels ago. I'll try
>> changing that but I thought I tried it once before.
>
> Ah, it's mode is 0444 (read-only).  Sorry I missed that piece.
> Sure, you could change the mode for your own use (rebuild the kernel).

 # cat /proc/sys/kernel/random/poolsize
16384
cat /proc/sys/kernel/random/entropy_avail
4096

I guess there is more to it.
