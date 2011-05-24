Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031128Ab1EXBV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:21:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37670 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031095Ab1EXBVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:21:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB082C.2030809@jp.fujitsu.com>
Date: Tue, 24 May 2011 10:21:48 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: rientjes@google.com
CC: caiqian@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram
 internally
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6204D.5020109@jp.fujitsu.com> <alpine.DEB.2.00.1105231522410.17840@chino.kir.corp.google.com> <alpine.DEB.2.00.1105231547060.17840@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105231547060.17840@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/24 7:48), David Rientjes wrote:
> On Mon, 23 May 2011, David Rientjes wrote:
>
>> I already suggested an alternative patch to CAI Qian to greatly increase
>> the granularity of the oom score from a range of 0-1000 to 0-10000 to
>> differentiate between tasks within 0.01% of available memory (16MB on CAI
>> Qian's 16GB system).  I'll propose this officially in a separate email.
>>
>
> This is an alternative patch as earlier proposed with suggested
> improvements from Minchan.  CAI, would it be possible to test this out on
> your usecase?
>
> I'm indifferent to the actual scale of OOM_SCORE_MAX_FACTOR; it could be
> 10 as proposed in this patch or even increased higher for higher
> resolution.

I did explain why your proposal is unacceptable.

http://www.gossamer-threads.com/lists/linux/kernel/1378837#1378837

