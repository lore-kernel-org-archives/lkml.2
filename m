Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2GXBTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:19:47 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38040 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab2GXBTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:19:45 -0400
Message-ID: <500DF828.3050102@linux.vnet.ibm.com>
Date: Tue, 24 Jul 2012 09:19:36 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
CC: Mike Galbraith <mgalbraith@novell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        dan.carpenter@oracle.com
Subject: Re: [QUESTION ON BUG] the rcu stall issue could not be reproduced
References: <5008CBD4.6070907@linux.vnet.ibm.com> <1342767624.7432.54.camel@marge.simpson.net> <500D9BFC.9090707@fold.natur.cuni.cz>
In-Reply-To: <500D9BFC.9090707@fold.natur.cuni.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072401-0260-0000-0000-0000018FC6A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 02:46 AM, Martin Mokrejs wrote:
> Hi,
>   I see few more RCU bugs reported in bugzilla:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=43028
> https://bugzilla.kernel.org/show_bug.cgi?id=40092
> https://bugzilla.kernel.org/show_bug.cgi?id=42997
> 
> And, I placed my previous long email with logs at
> https://bugzilla.kernel.org/show_bug.cgi?id=45091
> 
> Hope this helps eventually once.

That's very helpful, I need some time to read and think about it, thanks
for the info ;-)

Regards,
Michael Wang
> Martin
> 
> Mike Galbraith wrote:
>> On Fri, 2012-07-20 at 11:09 +0800, Michael Wang wrote: 
>>> Hi, Mike, Martin, Dan
>>>
>>> I'm currently taking an eye on the rcu stall issue which was reported by
>>> you in the mail:
>>>
>>> rcu: endless stalls
>>> 	From: Mike Galbraith
>>> linux-3.4-rc7: rcu_sched self-detected stall on CPU
>>> 	From: Martin Mokrejs
>>> RCU stalls in linux-next
>>> 	From: Dan Carpenter
>>>
>>> I try to reproduce the issue on my X86 server with 12 cpu
>>
>> The 'endless stalls' box was 341.33333 times larger.  Dunno if you can
>> even set a serial port slow enough to approximate all cores trying to
>> gripe through a single pinhole simultaneously.
>>
>> -Mike
>>
>>
> 
> 


