Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1AEUHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:07:52 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12499 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1AEUHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 15:07:51 -0500
Message-ID: <4D24CF95.5090006@caviumnetworks.com>
Date: Wed, 05 Jan 2011 12:07:49 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
References: <cover.1294239591.git.jbaron@redhat.com> <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com> <4D24AB1B.2010209@caviumnetworks.com> <1294249439.26623.35.camel@gandalf.stny.rr.com> <4D24BED1.5000900@zytor.com> <20110105191424.GA7820@elte.hu> <4D24C756.9070302@caviumnetworks.com> <20110105195043.GA9399@elte.hu>
In-Reply-To: <20110105195043.GA9399@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2011 20:07:49.0574 (UTC) FILETIME=[3A172E60:01CBAD14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 11:50 AM, Ingo Molnar wrote:
>
> * David Daney<ddaney@caviumnetworks.com>  wrote:
>
>> On 01/05/2011 11:14 AM, Ingo Molnar wrote:
>>>
>>> * H. Peter Anvin<hpa@zytor.com>   wrote:
>>>
>>>> On 01/05/2011 09:43 AM, Steven Rostedt wrote:
>>>>> On Wed, 2011-01-05 at 09:32 -0800, David Daney wrote:
>>>>>
>>>>>> This patch will conflict with the MIPS jump label support that Ralf has
>>>>>> queued up for 2.6.38.
>>>>>
>>>>> Can you disable that support for now? As Linus said at Kernel Summit,
>>>>> other archs jumped too quickly onto the jump label band wagon. This
>>>>> change really needs to get in, and IMO, it is more critical to clean up
>>>>> the jump label code than to have other archs implementing it.
>>>>>
>>>>
>>>> Ralf is really good... perhaps we can get the conflicts resolved?
>>>
>>> Yep, the best Git-ish way to handle that is to resolve the conflicts whenever they
>>> happen - i.e. whoever merges his tree upstream later. No need for anyone to 'wait'
>>> or undo anything.
>>>
>>
>> There will be no git conflicts, as the affected files are disjoint.
>
> I regularly resolve semantic conflicts in merge commits - or in the first followup
> commit.
>

But I am guessing that neither you, nor Linus, regularly build MIPS 
kernels with GCC-4.5.x *and* jump label support enabled.  So how would 
such semantic conflict ever be detected?  I would expect the conflict to 
first occur when Linus pulls Ralf's tree.

I don't expect anybody to magically fix such things, so whatever 
happens, I will test it and submit patches if required.

Thanks,
David Daney
