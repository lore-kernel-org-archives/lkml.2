Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab1CXDn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:43:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56481 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932926Ab1CXDnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:43:55 -0400
Message-ID: <4D8ABE6C.7000105@cn.fujitsu.com>
Date: Thu, 24 Mar 2011 11:45:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 01/11] rcu: call __rcu_read_unlock()
 in exit_rcu for tiny RCU
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-1-git-send-email-paulmck@linux.vnet.ibm.com> <4D67687A.6010906@cn.fujitsu.com> <20110225194007.GC2269@linux.vnet.ibm.com>
In-Reply-To: <20110225194007.GC2269@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-24 11:42:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-24 11:42:27,
	Serialize complete at 2011-03-24 11:42:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2011 03:40 AM, Paul E. McKenney wrote:
> On Fri, Feb 25, 2011 at 04:29:46PM +0800, Lai Jiangshan wrote:
>> On 02/23/2011 09:39 AM, Paul E. McKenney wrote:
>>>
>>> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
>>> index 015abae..3cb8e36 100644
>>> --- a/kernel/rcutiny_plugin.h
>>> +++ b/kernel/rcutiny_plugin.h
>>
>> My original patch was just for tree RCU. It is not merged.
>> I forgot the tiny RCU case then, this change is needed for tree & tiny RCU.
> 
> Good catch, I have applied the TREE_RCU patch.  I intend to submit
> both for the next merge window.
> 

Hi, Paul

It is still not merged, and it is not in your git tree.

I'm writing some patches, to avoid conflict with your code,
which branch I should based on?

Is origin/rcu/next OK?

Thanks,
Lai
