Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1AVSmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 13:42:39 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:46353 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1AVSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 13:42:37 -0500
Message-ID: <4D3B2519.6050307@oldelvet.org.uk>
Date: Sat, 22 Jan 2011 18:42:33 +0000
From: Richard Mortimer <richm@oldelvet.org.uk>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
References: <20110119221327.GA23544@Krystal> <20110119.142137.184823805.davem@davemloft.net> <20110119223339.GD23544@Krystal> <20110119.164107.135521108.davem@davemloft.net> <20110121000421.GA5014@Krystal> <4D39CB0C.8070308@oldelvet.org.uk> <20110121185259.GA13198@Krystal> <4D39E913.8060104@oldelvet.org.uk> <20110121204033.GA14125@Krystal> <4D3A0DC9.8010101@oldelvet.org.uk>
In-Reply-To: <4D3A0DC9.8010101@oldelvet.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/2011 22:50, Richard Mortimer wrote:
>
>
> On 21/01/2011 20:40, Mathieu Desnoyers wrote:
>> * Richard Mortimer (richm@oldelvet.org.uk) wrote:
>>
>> Thanks for the info! At first glance, it does not seem to contradict my
>> findings. When you find time, can you have a try at v3 I just posted ?
>>
> I'm setting the compilation off now. I will give it a whirl some time
> Saturday or Sunday.
>
...

>
>> Make sure to start tracing in your tests, as I think the unaligned
>> access only
>> happens when accessing the struct tracepoint fields below the "int
>> state" field.
>>

I have the revised patch running now with tracing enabled. Everything 
looks good to me.

Thanks.

Richard
