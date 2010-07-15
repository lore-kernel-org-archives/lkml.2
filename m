Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab0GOF3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 01:29:42 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47753 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab0GOF3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 01:29:39 -0400
Message-ID: <4C3E9CBB.202@us.ibm.com>
Date: Wed, 14 Jul 2010 22:29:31 -0700
From: Sridhar Samudrala <sri@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH repost] sched: export sched_set/getaffinity to modules
References: <20100701144624.GA11171@redhat.com> <4C2CABF2.2020801@kernel.org> <1277996135.1917.198.camel@laptop> <4C2E2987.9040702@us.ibm.com> <1278094270.1917.288.camel@laptop> <20100702210637.GA12433@redhat.com> <20100704090005.GA8078@redhat.com> <4C3C0EBC.40305@us.ibm.com> <20100713110939.GA3446@redhat.com> <1279149996.32374.5.camel@w-sridhar.beaverton.ibm.com> <20100715000506.GB27258@redhat.com>
In-Reply-To: <20100715000506.GB27258@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/2010 5:05 PM, Oleg Nesterov wrote:
> On 07/14, Sridhar Samudrala wrote:
>    
>> OK. So we want to create a thread that is a child of kthreadd, but inherits the cgroup/cpumask
>> from the caller. How about an exported kthread function kthread_create_in_current_cg()
>> that does this?
>>      
> Well. I must admit, this looks a bit strange to me ;)
>
> Instead of exporting sched_xxxaffinity() we export the new function
> which calls them. And I don't think this new helper is very useful
> in general. May be I am wrong...
>    
If we agree on exporting sched_xxxaffinity() functions, we don't need 
this new kthread function and we
can do the same in vhost as the original patch did.

Thanks
Sridhar

