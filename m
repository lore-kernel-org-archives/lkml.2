Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2FUGf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:35:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38599 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab2FUGft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:35:49 -0400
Message-ID: <4FE2C0BC.6020002@gmail.com>
Date: Thu, 21 Jun 2012 14:35:40 +0800
From: Charles Wang <muming.wq@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Doug Smythies <dsmythies@telus.net>
CC: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Yong Zhang'" <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>, "'Tao Ma'" <tm@tao.ma>,
        =?ISO-2022-JP?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>		 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>		 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com>		 <1340035417.15222.95.camel@twins> <20120619060824.GA31684@zhy>	 <1340097532.21745.19.camel@twins> <000001cd4e33$496f6c30$dc4e4490$@net> <1340185528.21745.86.camel@twins> <002301cd4f64$17a055c0$46e10140$@net>
In-Reply-To: <002301cd4f64$17a055c0$46e10140$@net>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 21, 2012 12:12 PM, Doug Smythies wrote:

> 
>>> On Tue, 2012-06-19 at 08:50 -0700, Doug Smythies wrote:
>>  On 2012.06.20 02:45 -0700, Peter Zijlstra wrote:
> 
>>> My automated 63 hour test has been terminated, the code changed
>>> and the test re-started. 
> 
>> There's another boo-boo in there:
> 
> O.K. I let the automated test finish the 3 processes stuff
> (which is 1/2 way).
> The newly compiled code is now running, but I only resumed
> the test, I did not re-start it.
> 
> A comparative graph of the 1 & 2 process results is attached.
> (the previous version of this same graph was on another thread).
> Legend:
> Control: older kernel compiled with CONFIG_NO_HZ=no
> c308: Kernel with the earlier commit
> 5aaa: Basically, Kernel 3.5 RC2
> Wang: Charles Wang's first proposed solution.
> Peter35: Peter Zijlstra's current proposed solution.
> 
> Summary: Extremely good.
> 


Finally resolved!!   ^____^
