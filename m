Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0EEGea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 02:34:30 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:43483 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755713Ab0EEGe3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 02:34:29 -0400
Message-ID: <4BE11169.3010602@tu-dresden.de>
Date: Wed, 05 May 2010 08:34:17 +0200
From: =?ISO-8859-15?Q?Ronny_Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Tracing of power:power_start events doesn't work
References: <4BDECD66.2010906@tu-dresden.de> <1273019517.22438.10.camel@gandalf.stny.rr.com>
In-Reply-To: <1273019517.22438.10.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-05-05 02:31, Steven Rostedt wrote:
> On Mon, 2010-05-03 at 15:19 +0200, Ronny Tschüter wrote:
>    
>> Hello,
>>
>> i use kernel version 2.6.33.2 (x86-64, Core 2 Duo) and the perf events
>> to track frequency and c states of my cpu. But if i want to trace
>> power:power_start events, it does not work. After typing
>>
>> echo "power:power_start" | sudo tee set_event
>>
>> on the console, the trace doesn't contain such events.
>> power:power_frequency and power:power_end events are reported correctly
>> by the system. I read in the mailing list that Robert Schoene had a
>> similiar problem, but with power:power_end events. Is there a known bug
>> regarding to trace_power_start methods in process.c?
>>      
> Is this for perf or ftrace? I'm assuming you did this from the debugfs
> tracing directory. The set_event file is for ftrace not perf.
>    
It is for perf - i'm interested in event tracing. I used the event 
tracing system like it is described in Documentation/trace/events.txt. 
In addition i wrote a program which uses syscall(__NR_perf_counter_open, 
... ) to trace power events. But the result is the same - 
power:power_end events are reported, power:power_start events not.

Bye Ronny
