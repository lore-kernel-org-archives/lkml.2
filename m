Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2GWCh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:37:56 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38417 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2GWChz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 22:37:55 -0400
Message-ID: <500CB8F6.3000208@linux.vnet.ibm.com>
Date: Mon, 23 Jul 2012 10:37:42 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mike Galbraith <mgalbraith@novell.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        mmokrejs@fold.natur.cuni.cz, dan.carpenter@oracle.com
Subject: Re: [QUESTION ON BUG] the rcu stall issue could not be reproduced
References: <5008CBD4.6070907@linux.vnet.ibm.com> <1342767624.7432.54.camel@marge.simpson.net> <5009170E.1080807@linux.vnet.ibm.com> <1342775305.7432.76.camel@marge.simpson.net>
In-Reply-To: <1342775305.7432.76.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072302-7014-0000-0000-0000019A518E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 05:08 PM, Mike Galbraith wrote:
> On Fri, 2012-07-20 at 16:30 +0800, Michael Wang wrote: 
>> On 07/20/2012 03:00 PM, Mike Galbraith wrote:
>>> On Fri, 2012-07-20 at 11:09 +0800, Michael Wang wrote: 
>>>> Hi, Mike, Martin, Dan
>>>>
>>>> I'm currently taking an eye on the rcu stall issue which was reported by
>>>> you in the mail:
>>>>
>>>> rcu: endless stalls
>>>> 	From: Mike Galbraith
>>>> linux-3.4-rc7: rcu_sched self-detected stall on CPU
>>>> 	From: Martin Mokrejs
>>>> RCU stalls in linux-next
>>>> 	From: Dan Carpenter
>>>>
>>>> I try to reproduce the issue on my X86 server with 12 cpu
>>>
>>> The 'endless stalls' box was 341.33333 times larger.  Dunno if you can
>>> even set a serial port slow enough to approximate all cores trying to
>>> gripe through a single pinhole simultaneously.
>>
>> Hi, Mike
>>
>> Thanks for your reply.
>>
>> So you mean this issue is still existing on you box and you can see it
>> without doing any special things?
> 
> It's not my box (thank god).  It was initially triggered by tasks
> exiting simultaneously on all cores.  They jammed up, endless stall
> followed.
> 
>> I just want to try to reproduce it but it's impossible for me to get
>> some hardware as yours...
>>
>> So is there any idea on how to reproduce it on normal hardware?
> 
> No, AFAIK this problem is restricted to size XXL boxen, with all the
> joys that come along with having way too many CPUs.

I see, thanks for your info, looks like it's hard to reproduce on normal
servers like mine...

Regards,
Michael Wang
> 
> -Mike
> 


