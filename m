Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2GTIaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:30:21 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36643 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2GTIaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:30:17 -0400
Message-ID: <5009170E.1080807@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 16:30:06 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mike Galbraith <mgalbraith@novell.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        mmokrejs@fold.natur.cuni.cz, dan.carpenter@oracle.com
Subject: Re: [QUESTION ON BUG] the rcu stall issue could not be reproduced
References: <5008CBD4.6070907@linux.vnet.ibm.com> <1342767624.7432.54.camel@marge.simpson.net>
In-Reply-To: <1342767624.7432.54.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072008-6102-0000-0000-000001E82567
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 03:00 PM, Mike Galbraith wrote:
> On Fri, 2012-07-20 at 11:09 +0800, Michael Wang wrote: 
>> Hi, Mike, Martin, Dan
>>
>> I'm currently taking an eye on the rcu stall issue which was reported by
>> you in the mail:
>>
>> rcu: endless stalls
>> 	From: Mike Galbraith
>> linux-3.4-rc7: rcu_sched self-detected stall on CPU
>> 	From: Martin Mokrejs
>> RCU stalls in linux-next
>> 	From: Dan Carpenter
>>
>> I try to reproduce the issue on my X86 server with 12 cpu
> 
> The 'endless stalls' box was 341.33333 times larger.  Dunno if you can
> even set a serial port slow enough to approximate all cores trying to
> gripe through a single pinhole simultaneously.

Hi, Mike

Thanks for your reply.

So you mean this issue is still existing on you box and you can see it
without doing any special things?

I just want to try to reproduce it but it's impossible for me to get
some hardware as yours...

So is there any idea on how to reproduce it on normal hardware?

Regards,
Michael Wang

> 
> -Mike
> 


