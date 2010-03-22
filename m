Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0CVMte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:49:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0CVMtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:49:33 -0400
Message-ID: <4BA76746.1000505@redhat.com>
Date: Mon, 22 Mar 2010 14:49:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <4BA6900B.1040408@redhat.com> <20100321215207.GA13219@elte.hu> <4BA712F0.5030806@redhat.com> <20100322112340.GD3483@elte.hu>
In-Reply-To: <20100322112340.GD3483@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 01:23 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> IMO the reason perf is more usable than oprofile has less to do with the
>> kernel/userspace boundary and more do to with effort and attention spent on
>> the userspace/user boundary.
>>
>> [...]
>>      
> If you are interested in the first-hand experience of the people who are doing
> the perf work then here it is: by far the biggest reason for perf success and
> perf usability is the integration of the user-space tooling with the
> kernel-space bits, into a single repository and project.
>    

Please take a look at the kvm integration code in qemu as a fraction of 
the whole code base.

> The very move you are opposing so vehemently for KVM.
>    

I don't want to fracture a working community.

> Oprofile went the way you proposed, and it was a failure. It failed not
> because it was bad technology (it was pretty decent and people used it), it
> was not a failure because the wrong people worked on it (to the contrary, very
> capable people worked on it), it was a failure in hindsight because it simply
> incorrectly split into two projects which stiffled the progress of each other.
>    

Every project that has some kernel footprint, except perf, is split like 
that.  Are they all failures?

Seems like perf is also split, with sysprof being developed outside the 
kernel.  Will you bring sysprof into the kernel?  Will every feature be 
duplicated in prof and sysprof?

-- 
error compiling committee.c: too many arguments to function

