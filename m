Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab1GOFPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:15:54 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42365 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab1GOFPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:15:53 -0400
MIME-Version: 1.0
In-Reply-To: <CABi1daHh7cgyhJ4c3zo+jSUY4uzbFtihtgw0Q2Mcrndno_gcTA@mail.gmail.com>
References: <CAJ8eaTzLmSTSMOY-0Xg0tE-DEbZ6RNA+uh70Dn3K5CbrjQsEiA@mail.gmail.com>
	<CABi1daHh7cgyhJ4c3zo+jSUY4uzbFtihtgw0Q2Mcrndno_gcTA@mail.gmail.com>
Date: Fri, 15 Jul 2011 10:45:52 +0530
Message-ID: <CAJ8eaTyqOBq2mbfvuTun=bVvhFSrMqJ5uVyd+cozF5PtVeSVaw@mail.gmail.com>
Subject: Re: ARM cortex A9 feature
From: naveen yadav <yad.naveen@gmail.com>
To: Dave Hylands <dhylands@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi dave,

Thanks for answering, but I think question 2, answer  is still not clear to me .

my question is why exclusive L2.

8.1.4 Exclusive L2 cache
The Cortex-A9 processor can be connected to an L2 cache that supports
an exclusive cache
mode. This mode must be activated both in the Cortex-A9 processor and
in the L2 cache
controller.
In this mode, the data cache of the Cortex-A9 processor and the L2
cache are exclusive. At any
time, a given address is cached in either L1 data caches or in the L2
cache, but not in both. This
has the effect of greatly increasing the usable space and efficiency
of an L2 cache connected to
the Cortex-A9 processor. When exclusive cache configuration is selected:
• Data cache line replacement policy is modified so that the victim
line always gets evicted
to L2 memory, even if it is clean.
• If a line is dirty in the L2 cache controller, a read request to this address


what is usecase for this . This is my question .

Thanks


On Thu, Jul 14, 2011 at 10:26 PM, Dave Hylands <dhylands@gmail.com> wrote:
> Hi Naveen,
>
> On Wed, Jul 13, 2011 at 11:26 PM, naveen yadav <yad.naveen@gmail.com> wrote:
>> Hi All,
>>
>> I am reading ARM cortex a9 manual and got few question in mind.
>>
>> 1. Where I need strong order type memory ? any sample example is very helpfull.
>
> Often when dealing with hardware, you need to ensure that when your code does:
>
> reg1 = val1;
> reg2 = val2;
>
> that these writes actually occur in the order that the code issues
> them. Using volatile pointers will get the compiler to not reorder the
> instructions, but you still need the writes to hit the hardware in the
> same order that they were issued. Using strongly ordered memory is one
> way to achieve that.
>
>> 2. L2 cache, Cortex a9 support exclusive L2 cache feature, where we need it ?
>
> L2 cache can improve your performance.
>
> --
> Dave Hylands
> Shuswap, BC, Canada
> http://www.davehylands.com
>
