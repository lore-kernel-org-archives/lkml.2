Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab0CRLbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 07:31:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab0CRLbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:31:45 -0400
Message-ID: <4BA20EB8.60707@redhat.com>
Date: Thu, 18 Mar 2010 13:30:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu>
In-Reply-To: <20100318105013.GB24464@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 12:50 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> The moment any change (be it as trivial as fixing a GUI detail or as
>>> complex as a new feature) involves two or more packages, development speed
>>> slows down to a crawl - while the complexity of the change might be very
>>> low!
>>>        
>> Why is that?
>>      
> It's very simple: because the contribution latencies and overhead compound,
> almost inevitably.
>    

It's not inevitable, if the projects are badly run, you'll have high 
latencies, but projects don't have to be badly run.

> If you ever tried to implement a combo GCC+glibc+kernel feature you'll know
> ...
>
> Even with the best-run projects in existence it takes forever and is very
> painful - and here i talk about first hand experience over many years.
>    

Try sending a patch to qemu-devel@, you may be pleasantly surprised.


>> I the maintainers of all packages are cooperative and responsive, then the
>> patches will get accepted quickly.  If they aren't, development will be
>> slow. [...]
>>      
> I'm afraid practice is different from the rosy ideal you paint there. Even
> with assumed 'perfect projects' there's always random differences between
> projects, causing doubled (tripled) overhead and compounded up overhead:
>
>   - random differences in release schedules
>
>   - random differences in contribution guidelines
>
>   - random differences in coding style
>    

None of these matter for steady contributors.

>> [...] It isn't any different from contributing to two unrelated kernel
>> subsystems (which are in fact in different repositories until the next merge
>> window).
>>      
> You mention a perfect example: contributing to multipe kernel subsystems. Even
> _that_ is very noticeably harder than contributing to a single subsystem - due
> to the inevitable buerocratic overhead, due to different development trees,
> due to different merge criteria.
>
> So you are underlining my point (perhaps without intending to): treating
> closely related bits of technology as a single project is much better.
>
> Obviously arch/x86/kvm/, virt/ and tools/kvm/ should live in a single
> development repository (perhaps micro-differentiated by a few topical
> branches), for exactly those reasons you mention.
>    

How is a patch for the qemu GUI eject button and the kvm shadow mmu 
related?  Should a single maintainer deal with both?


-- 
error compiling committee.c: too many arguments to function

