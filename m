Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab2EXOHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:07:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:12744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab2EXOHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170879016"
Message-ID: <4FBE4082.5080708@intel.com>
Date: Thu, 24 May 2012 22:06:58 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: borislav.petkov@amd.com, arnd@arndb.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, akinobu.mita@gmail.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        hughd@google.com, jeremy@goop.org, len.brown@intel.com,
        tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, luto@mit.edu,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, cpw@sgi.com, steiner@sgi.com,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hpa@zytor.com
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com> <1337782555-8088-9-git-send-email-alex.shi@intel.com> <4FBD18D20200007800085951@nat28.tlf.novell.com> <1337792984.9783.37.camel@laptop> <4FBDF200.7060608@intel.com> <1337848970.9783.72.camel@laptop> <4FBDFF11.7030105@intel.com> <4FBE1FAA0200007800085CC4@nat28.tlf.novell.com>
In-Reply-To: <4FBE1FAA0200007800085CC4@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 05:46 PM, Jan Beulich wrote:

>>>> On 24.05.12 at 11:27, Alex Shi <alex.shi@intel.com> wrote:
>> On 05/24/2012 04:42 PM, Peter Zijlstra wrote:
>>
>>> On Thu, 2012-05-24 at 16:32 +0800, Alex Shi wrote:
>>>> So, I use cpumask_t in stack.
>>>
>>> cpumask_t is 512 bytes with NR_CPUS=4096, that's generally considered
>>> too big to be on stack.
>>
>>
>> I am not consistent with cpumask_t.
>> I just want to know why it is too big on stack? Since if it causes
>> trouble in using, that mean current kernel will fail to run on 4096 CPU
>> system.
> 
> Why? Did you spot critical left-over instances of on-stack
> cpumask_t-s anywhere?


I aware it is a stupid question just after the e-mail sent out.
Thanks for you and PeterZ's nice reply!

> 
> Jan
> 


