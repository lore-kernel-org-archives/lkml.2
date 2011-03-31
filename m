Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1CaBAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:00:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56295 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab1CaBAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:00:19 -0400
Message-ID: <4D93D29C.5010702@cn.fujitsu.com>
Date: Thu, 31 Mar 2011 09:02:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, paulmck@linux.vnet.ibm.com,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF9BC.7050609@cn.fujitsu.com>	 <4D90647902000078000389CB@vpn.id2.novell.com>	 <4D924BAF.1020906@linux.intel.com>	 <20110329213130.GK2261@linux.vnet.ibm.com>	 <4D924FEE.8040804@linux.intel.com>	 <20110329214704.GM2261@linux.vnet.ibm.com>	 <4D9256AF.5000308@linux.intel.com>	 <20110330004725.GO2261@linux.vnet.ibm.com> <4D92BECA.50802@cn.fujitsu.com>	 <4D92DA32.2010809@cn.fujitsu.com>  <20110330105505.GA3195@sepie.suse.cz> <1301482656.4859.171.camel@twins> <4D931814.9090100@suse.cz>
In-Reply-To: <4D931814.9090100@suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-31 08:58:40,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-31 08:58:43,
	Serialize complete at 2011-03-31 08:58:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 07:46 PM, Michal Marek wrote:
> On 30.3.2011 12:57, Peter Zijlstra wrote:
>> On Wed, 2011-03-30 at 12:55 +0200, Michal Marek wrote:
>>> Subject: [PATCH] headers: Allow for lightweight inclusion of task_struct definition
>>>
>>> Factor out a couple of type definitions to <header>_types.h to allow
>>> using task_struct without pulling tons of new dependencies via sched.h.
>>
>> Urgh, not pretty.. so why not clean up sched.h properly? There's way too
>> much cruft in there.
> 
> It was a proof-of-concept to show that it is doable to have proper
> definition of task_struct in rcupdate.h. Not an entry for any code
> beauty contest.
> 
> Michal
> 

I like this cleanup, could you continue for this hard job? I will help you if required.

Ingo & Peter - will you accept the patches when it is done.

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
