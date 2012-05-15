Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab2EOIlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:41:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62927 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2EOIlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:41:47 -0400
Message-ID: <4FB216C7.6020604@gmail.com>
Date: Tue, 15 May 2012 10:41:43 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        smuckle@quicinc.com, khilman@ti.com, Robin.Randhawa@arm.com,
        suresh.b.siddha@intel.com, thebigcorporation@gmail.com,
        venki@google.com, peterz@infradead.org, panto@antoniou-consulting.com,
        mingo@elte.hu, paul.brett@intel.com, pdeschrijver@nvidia.com,
        pjt@google.com, efault@gmx.de, fweisbec@gmail.com, geoff@infradead.org,
        tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel@vger.kernel.org, linaro-sched-sig@lists.linaro.org
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com> <1336753616.14207.258.camel@gandalf.stny.rr.com> <CAKfTPtA8EJeYVfpYTF7sh44ANOCUzE_eLkmYgE+bg25Vsgoj1Q@mail.gmail.com>
In-Reply-To: <CAKfTPtA8EJeYVfpYTF7sh44ANOCUzE_eLkmYgE+bg25Vsgoj1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 06:38 PM, Vincent Guittot wrote:
> On 11 May 2012 18:26, Steven Rostedt<rostedt@goodmis.org>  wrote:
>> Not really specific to HW, but Juri Lelli has been working on a deadline
>> scheduler. Perhaps his work may be of interest.
>
> Yes for sure, if Juri is agree to present his work
>

Sure! It will be really interesting for me.
I'm setting up the proposal. I'll send it today.

Thanks and Regards,

- Juri
  
> Vincent
>>
>> -- Steve
>>
>>
>> On Fri, 2012-05-11 at 18:16 +0200, Vincent Guittot wrote:
>>> This is a request-for-participation in a micro conference during the
>>> next Linux Plumber Conference (29-31st Aug).
>>> It'll require critical mass measured in talk submissions in the
>>> general area of scheduler and task management.
>>>
>>> If you're working on improving the the scheduler policy used to place
>>> a task on a CPU to suit your HW, we are inviting your participation
>>> and request you to submit a proposal to present your problem (e.g.
>>> power-efficiency) or a solution to solve said problem that should be
>>> considered by upstream developers.
>>>
>>> We've interacted with the people in To: list before in our quest to
>>> better understand how the scheduler works and we're hoping you all
>>> will consider participating in the micro-conf to help guide what kinds
>>> of ideas are likely to make it upstream.
>>>
>>> If you have ongoing work or ideas in the the following areas we're
>>> especially interested in hearing from you:
>>>   1. Consolidation of statistics with other frameworks (cpuidle,
>>> cpufreq, scheduler all seem to track their own statistics related to
>>> load, idleness, etc. Can this be converted to a library that is
>>> useable by all?)
>>>   2. Replacement for task consolidation on fewer CPUs aka. replacement
>>> for sched_mc
>>>   3. Improvement in the placement of activity beside tasks: timer,
>>> workqueue, IO, interruption
>>>   4. Instrumentation to calculate the compute capacity available on
>>> active cores and its utilization by a given workload
>>>
>>> We are thinking of organising the micro-conf as a Q&  A session where
>>> a participant would state a problem and then there would be
>>> brainstorming on if this is indeed a problem and is so, how to achieve
>>> a solution. In other words, 20-30 minute slots of each Q&  A
>>>
>>> 1. Problem statements with specific examples on why changing the
>>> default scheduler policy is desired
>>> 2. For each problem, if it is deemed not possible to accomplish easily
>>> today, brainstorming on what an acceptable solution would look like
>>> (frameworks to build upon, interfaces to use, related work in the
>>> area, key people to involve, etc.)
>>>
>>> Please email us if you will be attending the conference and interested
>>> in talking about this problem space.
>>>
>>> Regards,
>>> Amit&  Vincent
>>
>>
