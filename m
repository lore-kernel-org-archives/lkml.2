Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab1G0HNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 03:13:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65168 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1G0HNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 03:13:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110726194956.GA4117@tassilo.jf.intel.com>
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
	<m1r5n7ln0l.fsf@fess.ebiederm.org>
	<CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
	<20110726194956.GA4117@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 15:13:19 +0800
Message-ID: <CAKdQVUZgSJi4z1BnwnKiOjX7L2dhOyMxA018sS-MtqOQixSKeg@mail.gmail.com>
Subject: Re: x86_64 virtual memory map
From: Bob Zhang <zhanglinbao@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hayfeng Lee <omycle@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bob Zhang <2004.zhang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/27 Andi Kleen <ak@linux.intel.com>:
>> and in the end of mm.txt , it says :
>> >>Current X86-64 implementations only support 40 bits of address space,
>>  >> 27but we support up to 46 bits. This expands into MBZ space in the
>> >>page tables.
>> so this 40bit(1TB) is responding to virtual memory map(1TB) ?
>
> The 1TB limit was dropped a long time ago.
> Your googling found an old file.

I am not googling this , I get this file from lxr . I get that file
from kernel v3.0 again .
http://lxr.linux.no/linux+v3.0/Documentation/x86/x86_64/mm.txt
it still said 1TB limit, if this number is really obsolete , it seems
that related people should update it to correct number.thanks.

>
>> 3,  if I installed 64TB physical memory (RAM) , but linux kernel only
>
> What system is that out of curiosity? Are you sure it's not
> a cluster?
This system is HP's latest Proliant machine , DL980G7 .
I have verified with firmware guys , they have tested sles11sp1 on
DL980G7 ,2TB ,4TB ,they tested successfully. not BIOS problem. it
seems that customer's configuration may has some issues. we don't
think this is linux kernel issue again. thanks for help.

>
>> support 1TB address space , what should I do next ?
> There's no known 1TB limit currently.
so as you said below ,it should be 64TB, but no one test with 64TB really.

> However at least for Intel Xeons there is no CPU which supports
> more than 16TB physical address space.
This information is very important, I will check System spec for details.
which spec can get this information ? x86_64 ,which spec ?



>
> Are you sure you have your units correct?
>
hoho , I am not richer , I don't have 64TB installed, I just supposed that.
in fact, my DL980G7 just have 2 TB installed , but linux kernel
recognized only  992GB. as I said above , firmware guys said they have
tested 4TB on DL980G7 with sles11sp1 , so we are investigating why our
environment will happen this issue . wait for future reply.


another question:
For BIOS ,BIOS has absolutely supported 4TB+ ?
Does BIOS theoretically support 64TB ?

so I basicly understand what you mean , you mean intel Xeon just
support 16TB , linux kernel should have no issue to support this 16TB
?


thanks very much! If I have some update info , I will reply in time.

-Bob
