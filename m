Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2LQKwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 05:52:46 -0500
Received: from fallback.hitachi.co.jp ([133.145.228.50]:47316 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2LQKwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 05:52:45 -0500
X-AuditID: 85900ec0-d727cb900000152f-4c-50cef8e2887e
Message-ID: <50CEF8D9.6000208@hitachi.com>
Date: Mon, 17 Dec 2012 19:50:01 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v2 -tip 3/4] tracing: make a snapshot feature available
 from userspace
References: <20121017025608.2627.87497.stgit@falsita> 		 <20121017025619.2627.96794.stgit@falsita> 	 <1353030384.9391.19.camel@gandalf.local.home> 	 <50B84822.6010409@hitachi.com>  <1354285026.6276.157.camel@gandalf.local.home> <50C14F5A.50807@hitachi.com> <1355504913.17101.399.camel@gandalf.local.home>
In-Reply-To: <1355504913.17101.399.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/15/2012 02:08 AM), Steven Rostedt wrote:
> On Fri, 2012-12-07 at 11:07 +0900, Hiraku Toyooka wrote:
>> Hi, Steven,
>>
>> (2012/11/30 23:17), Steven Rostedt wrote:
>> [snip]
>>   >
>>   > Actually, I would have:
>>   >
>>   >   status\input |     0      |     1      |    else    |
>>   >  --------------+------------+------------+------------+
>>   >  not allocated |(do nothing)| alloc+swap |   EINVAL   |
>>   >  --------------+------------+------------+------------+
>>   >    allocated   |    free    |   swap     |   clear    |
>>   >  --------------+------------+------------+------------+
>>   >
>>   > Perhaps we don't need to do the clear on swap, just let the trace
>>   > continue where it left off? But in case we should swap...
>>   >
>>
>> I think we don't need the clear on swap too.
>> I'll update my patches like this table.
>>
>>   > There's a fast way to clear the tracer. Look at what the wakeup tracer
>>   > does. We can make that generic. If you want, I can write that code up
>>   > too. Hmm, maybe I'll do that, as it will speed things up for
>>   > everyone :-)
>>   >
>>
>
> BTW, any update on this? I really like to get this into 3.9.
>

I'm applying your review comment and rebasing now. So, I'll post the
updated patch series in a few days.

Thanks,
Hiraku Toyooka

