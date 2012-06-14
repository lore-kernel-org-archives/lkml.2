Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab2FNDNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:13:52 -0400
Received: from defout.telus.net ([204.209.205.33]:46575 "EHLO defout.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab2FNDNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:13:50 -0400
X-Authority-Analysis: v=1.1 cv=P+ZEdO0D3Q9E7TO7FitHuHm52J/mDxFTm8B8+6MwKwU=
 c=1 sm=2 a=d5aLr75umSEA:10 a=LGgl8L9ij00A:10 a=ZPSk82zQDygA:10
 a=h1iltqZIKrZIMbT6DgAA:9 a=UAVRJdkkkM0A:10
X-Telus-Outbound-IP: 209.121.28.192
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Peter Zijlstra'" <peterz@infradead.org>
Cc: "'Charles Wang'" <muming.wq@gmail.com>, <linux-kernel@vger.kernel.org>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Charles Wang'" <muming.wq@taobao.com>, "'Tao Ma'" <tm@tao.ma>,
        =?iso-2022-jp?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>,
        "Doug Smythies" <dsmythies@telus.net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>			 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>		 <1339494970.31548.66.camel@twins> <004701cd4929$200d4600$6027d200$@net>	 <1339575411.31548.107.camel@twins> <000601cd4979$e1fda7a0$a5f8f6e0$@net> <1339624653.8980.76.camel@twins>
In-Reply-To: <1339624653.8980.76.camel@twins>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
Date: Wed, 13 Jun 2012 20:13:29 -0700
Message-ID: <000101cd49db$b0d92a20$128b7e60$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1Jr5kUoez/natpS7uE6RUaoyRe1wAKhZSQ
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> On Wed, 2012-06-13 at 08:33 -0700, Doug Smythies wrote:
>  On 2012.06.13 14:58 -0700, Peter Zijlstra wrote:

>> 
>> All that being said, what I typically do with a new code test is:
>> 
>> . select a known, previous bad operating point. For example 2
>> processes, actual load average 0.30 (0.15 for each process) currently
>> reporting ~1.5. 

> OK, I'll try and apply this. Waiting 63 hours for feedback on patches is
> something I'm not patient enough for.

> Would this be: 

> ./waiter 2 900 230608 10000

Actually it would be:

./waiter 2 900 345912 9444

At least on my computer, with the CPUs locked into powersave mode (lowest
clock rate). It might be different on your computer as the exact numbers are
computer dependent.
I will change the script generating program to add comment lines as to the
expected execution scenario, as I have troubles also looking up command
lines.

> I haven't even bothered reading the waiter proglet yet, but I did notice
> the 'help' provided when started without arguments doesn't seem to
> actually match what load_180 does.

Right, sorry. I think you will find the newer version (from the "wang"
experiment write up) is O.K.




