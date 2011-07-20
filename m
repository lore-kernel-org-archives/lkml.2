Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1GTRE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:04:27 -0400
Received: from mail.candelatech.com ([208.74.158.172]:49023 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1GTRE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:04:26 -0400
Message-ID: <4E270A0E.6090902@candelatech.com>
Date: Wed, 20 Jul 2011 10:02:06 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Linus Torvalds <torvalds@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        edward.tomlinson@aero.bombardier.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads trainwreck
References: <20110720001738.GA16369@linux.vnet.ibm.com> <201107192130.02080.edt@aei.ca> <201107192207.33813.edt@aei.ca> <20110720044435.GB2400@linux.vnet.ibm.com> <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com> <20110720133443.GG2400@linux.vnet.ibm.com>
In-Reply-To: <20110720133443.GG2400@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 06:34 AM, Paul E. McKenney wrote:
> On Tue, Jul 19, 2011 at 10:03:05PM -0700, Linus Torvalds wrote:
>> On Tue, Jul 19, 2011 at 9:44 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com>  wrote:
>>> On Tue, Jul 19, 2011 at 10:07:32PM -0400, Ed Tomlinson wrote:
>>>> On Tuesday 19 July 2011 21:30:00 Ed Tomlinson wrote:
>>>>> On Tuesday 19 July 2011 20:17:38 Paul E. McKenney wrote:
>>>>
>>>> Paul,
>>>>
>>>> Two things to add.  Its possible an eariler error is missing from the log below.  My serial console was missing
>>>> entries from before '0 and 40ish' and I did think I saw a bunch of FFFFFFFs scroll by eariler...
>>>>
>>>> Second, booting with threadirqs and boost enabled in .config with patches 2,5,6 is ok so far.
>>>
>>> Patches 3 and 4 resulted in failures?  (Patch 1 certainly did.)
>>
>> Gaah. Any possibility of getting this resolved soon?
>
> I believe that we are very close.  These failures all involve unusual
> configurations, which is why they showed up so late.

What is strange about my configuration?  Just that I enabled the
RCU boost and other new RCU features?

Surely it's not that I'm just doing lots of mounts and unmounts
and file-io with lots of processes....

And I was posting lockdep warnings on this since -rc1 or so, though granted
I was running a few extra patches and having other bugs at the same time....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

