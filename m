Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1AVSxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 13:53:30 -0500
Received: from mail.openrapids.net ([64.15.138.104]:45052 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750801Ab1AVSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 13:53:28 -0500
Date: Sat, 22 Jan 2011 13:53:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Richard Mortimer <richm@oldelvet.org.uk>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110122185326.GA3969@Krystal>
References: <20110119.142137.184823805.davem@davemloft.net> <20110119223339.GD23544@Krystal> <20110119.164107.135521108.davem@davemloft.net> <20110121000421.GA5014@Krystal> <4D39CB0C.8070308@oldelvet.org.uk> <20110121185259.GA13198@Krystal> <4D39E913.8060104@oldelvet.org.uk> <20110121204033.GA14125@Krystal> <4D3A0DC9.8010101@oldelvet.org.uk> <4D3B2519.6050307@oldelvet.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3B2519.6050307@oldelvet.org.uk>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:53:18 up 59 days, 23:56,  5 users,  load average: 0.05, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Richard Mortimer (richm@oldelvet.org.uk) wrote:
> On 21/01/2011 22:50, Richard Mortimer wrote:
>>
>>
>> On 21/01/2011 20:40, Mathieu Desnoyers wrote:
>>> * Richard Mortimer (richm@oldelvet.org.uk) wrote:
>>>
>>> Thanks for the info! At first glance, it does not seem to contradict my
>>> findings. When you find time, can you have a try at v3 I just posted ?
>>>
>> I'm setting the compilation off now. I will give it a whirl some time
>> Saturday or Sunday.
>>
> ...
>
>>
>>> Make sure to start tracing in your tests, as I think the unaligned
>>> access only
>>> happens when accessing the struct tracepoint fields below the "int
>>> state" field.
>>>
>
> I have the revised patch running now with tracing enabled. Everything  
> looks good to me.

Thanks for testing it!

Mathieu

>
> Thanks.
>
> Richard

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
