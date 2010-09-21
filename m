Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0IUTz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:55:56 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:20846
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756195Ab0IUTzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:55:55 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zzbb2dK936eK146fK1432N98dN4015Lzz1202hzzz2fh2a8h61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4C990DC3.8040204@am.sony.com>
Date: Tue, 21 Sep 2010 12:55:47 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 3/4] tracing/sched: Add sched_rt_push and sched_rt_pull
 tracepoints
References: <20100921024002.672817629@goodmis.org>	 <20100921024139.095017089@goodmis.org>  <1285058793.2275.799.camel@laptop>	 <1285072416.23122.1723.camel@gandalf.stny.rr.com> <1285076187.23122.1809.camel@gandalf.stny.rr.com> <4C9906EE.3030506@am.sony.com>
In-Reply-To: <4C9906EE.3030506@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/10 12:26, Frank Rowand wrote:
> On 09/21/10 06:36, Steven Rostedt wrote:
>> On Tue, 2010-09-21 at 08:33 -0400, Steven Rostedt wrote:
>>
>>>> Why doesn't the migration tracepoint cover this? It shows you the task,
>>>> the prio, the old and new cpu. If the migration is logged from the old
>>>> cpu, its a push, if its logged from the new its a pull, no?
> 
> Slight nuance...
> 
> If the migration is logged from a cpu other than the new cpu, it is a push.

And since the logged from cpu can be different than the old cpu, the logged
from cpu can be additional useful debugging or analysis information.

> 
>>>
>>> For some reason it did not help me enough in my analysis. I'll go back
>>> and see why.
>>>
>>> I originally had these tracepoints at the front of the series, and
>>> realized they may be a little controversial, thus I moved them to the
>>> end.
>>
>> OK, I went back and looked, and I think you are right. I can determine
>> this from the migration tracepoint. I think I was just being lazy and
>> wanted to have the direction obvious to me :-)  I can easily do that by
>> adding a plugin.
>>
>> Anyway, I'll remove this patch and rename the sched_rt_setprio
>> tracepoint to sched_pi_setprio. Would that be OK with you?
>>
>> Thanks,
>>
>> -- Steve

Regards,

Frank

