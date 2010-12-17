Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0LQDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:09:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0LQDJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:09:28 -0500
Message-ID: <4D0AD4A8.7050206@cn.fujitsu.com>
Date: Fri, 17 Dec 2010 11:10:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: Lai Jiangshan <eag0628@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
References: <4D07330A.7020600@cn.fujitsu.com>	<alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>	<4D083900.1050801@cn.fujitsu.com>	<1292386606.5015.1862.camel@gandalf.stny.rr.com>	<4D0877D2.10000@cn.fujitsu.com>	<alpine.LFD.2.00.1012151029090.12146@localhost6.localdomain6> <AANLkTi=x-_ffBnFL4TMtjGBBpbu9aBvSHKiQ7BgNy7J0@mail.gmail.com> <4D0A77B5.3040900@linux.intel.com>
In-Reply-To: <4D0A77B5.3040900@linux.intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-17 11:09:23,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-17 11:09:24,
	Serialize complete at 2010-12-17 11:09:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 04:33 AM, Darren Hart wrote:
>> Hi, Thomas,
>>
>> Where can I find the code of stress testcases?
> 
> See http://rt.wiki.kernel.org, There are several benchmarks available
> for RT there.
> 
> I believe there are some built-int rt-mutex testers as well:\
> CONFIG_RT_MUTEX_TESTER
> 

Thank you very much,

I have tested the testcases in scripts/rt-tester/ with CONFIG_RT_MUTEX_TESTER=y

I also try to port it to -rt. Steven, have you ported it to -rt?

Thanks,
Lai.
