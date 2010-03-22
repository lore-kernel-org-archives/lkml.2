Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0CVR6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:58:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab0CVR6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:58:48 -0400
Message-ID: <4BA7AFBF.60503@redhat.com>
Date: Mon, 22 Mar 2010 19:58:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Frank Ch. Eigler" <fche@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org> <20100322163215.GC18796@elte.hu> <y0mmxy0wa1r.fsf@fche.csb> <84144f021003221027t1a3e7d6ft64612654c5e50da@mail.gmail.com> <4BA7A9AF.3010806@redhat.com> <20100322173923.GA25498@elte.hu>
In-Reply-To: <20100322173923.GA25498@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 07:39 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/22/2010 07:27 PM, Pekka Enberg wrote:
>>      
>>> It's kinda funny to see people argue that having an external repository is
>>> not a problem and that it's not a big deal if building something from the
>>> repository is slightly painful as long as it doesn't require a PhD when we
>>> have _real world_ experience that it _does_ limit developer base in some
>>> cases. Whether or not that applies to kvm remains to be seen but I've yet
>>> to see a convincing argument why it doesn't.
>>>        
>> qemu has non-Linux developers.  Not all of their contributions are relevant
>> to kvm but some are.  If we pull qemu into tools/kvm, we lose them.
>>      
> Qemu had very few developers before KVM made use of it - i know it because i
> followed the project prior KVM.
>    

No argument.

> So whatever development activitity Qemu has today, it's 99% [WAG] attributable
> to KVM. It might have non-Linux contributors, but they wouldnt be there if it
> wasnt for all the Linux contributors ...
>
> Furthermore, those contributors wouldnt have to leave - they could simply use
> a different Git URI ...
>    

tools/kvm would drop support for non-Linux hosts, for tcg, and for 
architectures which kvm doesn't support ("clean and minimal").  That 
would be the real win, not sharing the repository.  But those other 
contributors would just stay with the original qemu.

-- 
error compiling committee.c: too many arguments to function

