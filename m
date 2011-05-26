Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1EZDCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 23:02:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29380 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab1EZDCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 23:02:50 -0400
Message-ID: <4DDDC2A5.4030703@oracle.com>
Date: Wed, 25 May 2011 20:01:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: oleg@redhat.com, mingo@elte.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signal.c: fix kernel-doc warning
References: <20110525192815.01c9227f.randy.dunlap@oracle.com> <20110526025806.GA2426@gmail.com>
In-Reply-To: <20110526025806.GA2426@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4DDDC2B2.001E:SCFSTAT5015188,ss=1,pt=DBB_65838,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/11 19:58, Harry Wei wrote:
> On Wed, May 25, 2011 at 07:28:15PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix kernel-doc warnings in signal.c:
>>
>> Warning(kernel/signal.c:2374): No description found for parameter 'nset'
>> Warning(kernel/signal.c:2374): Excess function parameter 'set' description in 'sys_rt_sigprocmask'
> Hi Randy,
> 	I wonder how you can get the warning of the comments.
> IMO, gcc can not get the comments' errors or warnings. Maybe
> you just use scripts for this. Would you mind telling me ;)

Harry,

I just run "make htmldocs" and watch the messages.

> Thanks
> Harry Wei
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Harry Wei <harryxiyou@gmail.com>
>> ---
>>  kernel/signal.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-2.6.39-git10.orig/kernel/signal.c
>> +++ linux-2.6.39-git10/kernel/signal.c
>> @@ -2365,7 +2365,7 @@ int sigprocmask(int how, sigset_t *set, 
>>  /**
>>   *  sys_rt_sigprocmask - change the list of currently blocked signals
>>   *  @how: whether to add, remove, or set signals
>> - *  @set: stores pending signals
>> + *  @nset: stores pending signals
>>   *  @oset: previous value of signal mask if non-null
>>   *  @sigsetsize: size of sigset_t type
>>   */
>> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
