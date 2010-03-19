Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab0CSH4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:56:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0CSH4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:56:40 -0400
Message-ID: <4BA32E1A.2060703@redhat.com>
Date: Fri, 19 Mar 2010 09:56:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
References: <4BA21B09.6060706@redhat.com> <20100318130047.GA7424@elte.hu> <4BA23FE1.5050402@codemonkey.ws> <20100318151737.GA2875@elte.hu> <4BA250BF.80704@codemonkey.ws> <20100318162853.GB447@elte.hu> <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu>
In-Reply-To: <20100318172805.GB26067@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 07:28 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/18/2010 07:02 PM, Ingo Molnar wrote:
>>      
>>> I find the 'KVM mostly cares about the server, not about the desktop'
>>> attitude expressed in this thread troubling.
>>>        
>> It's not kvm, just it's developers (and their employers, where applicable).
>> If you post desktop oriented patches I'm sure they'll be welcome.
>>      
> Just such a patch-set was posted in this very thread: 'perf kvm'.
>
> There were two negative reactions immediately, both showed a fundamental
> server versus desktop bias:
>
>   - you did not accept that the most important usecase is when there is a
>     single guest running.
>    

Well, it isn't.

>   - the reaction to the 'how do we get symbols out of the guest' sub-question
>     was, paraphrased: 'we dont want that due to<unspecified>  security threat
>     to XYZ selinux usecase with lots of guests'.
>    

When I review a patch, I try to think of the difficult cases, not just 
the easy case.

> Anyone being aware of how Linux and KVM is being used on the desktop will know
> how detached that attitude is from the typical desktop usecase ...
>
> Usability _never_ sucks because of lack of patches or lack of suggestions. I
> bet if you made the next server feature contingent on essential usability
> fixes they'd happen overnight - for God's sake there's been 1000 commits in
> the last 3 months in the Qemu repository so there's plenty of manpower...
>    

First of all I am not a qemu maintainer.  Second, from my point of view 
all contributors are volunteers (perhaps their employer volunteered 
them, but there's no difference from my perspective).  Asking them to 
repaint my apartment as a condition to get a patch applied is abuse.  If 
a patch is good, it gets applied.

> Usability suckage - and i'm not going to be popular for saying this out loud -
> almost always shows a basic maintainer disconnect with the real world. See
> your very first reactions to my 'KVM usability' observations. Read back your
> and Anthony's replies: total 'sure, patches welcome' kind of indifference. It
> is _your project_, not some other project down the road ...
>    

I could drop everything and write a gtk GUI for qemu.  Is that what you 
want?

If someone is truly interested in a qemu usability, it's up to them to 
write the patches.  Personally I've never missed the eject button.

As to disconnect from the real world, most products based on kvm and 
qemu (and Linux) are server based.  Perhaps that's the reason people 
emphasise that?  Maybe if Linux had 10-20% desktop market penetration, 
there would be more interest in a bells and whistles qemu GUI.

> So that is my first-hand experience about how you are welcoming these desktop
> issues, in this very thread. I suspect people try a few times with
> suggestions, then get shot down like our suggestions were shot down and then
> give up.
>    

I don't recall anyone trying this much less being shot down.  Perhaps 
people are concentrating on virt-manager and the like and leaving qemu 
alone.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

