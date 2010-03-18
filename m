Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0CRWUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:20:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab0CRWUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:20:39 -0400
Message-ID: <4BA2A70B.5080101@redhat.com>
Date: Thu, 18 Mar 2010 12:19:55 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA294D4.2060700@redhat.com> <20100318211529.GA21367@elte.hu>
In-Reply-To: <20100318211529.GA21367@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 11:15 AM, Ingo Molnar wrote:
> * Zachary Amsden<zamsden@redhat.com>  wrote:
>
>    
>> On 03/18/2010 12:50 AM, Ingo Molnar wrote:
>>      
>>> * Avi Kivity<avi@redhat.com>   wrote:
>>>
>>>        
>>>>> The moment any change (be it as trivial as fixing a GUI detail or as
>>>>> complex as a new feature) involves two or more packages, development speed
>>>>> slows down to a crawl - while the complexity of the change might be very
>>>>> low!
>>>>>            
>>>> Why is that?
>>>>          
>>> It's very simple: because the contribution latencies and overhead compound,
>>> almost inevitably.
>>>
>>> If you ever tried to implement a combo GCC+glibc+kernel feature you'll know
>>> ...
>>>
>>> Even with the best-run projects in existence it takes forever and is very
>>> painful - and here i talk about first hand experience over many years.
>>>        
>> Ingo, what you miss is that this is not a bad thing.  Fact of the
>> matter is, it's not just painful, it downright sucks.
>>      
> Our experience is the opposite, and we tried both variants and report about
> our experience with both models honestly.
>
> You only have experience about one variant - the one you advocate.
>
> See the assymetry?
>
>    
>> This is actually a Good Thing (tm).  It means you have to get your
>> feature and its interfaces well defined and able to version forwards
>> and backwards independently from each other.  And that introduces
>> some complexity and time and testing, but in the end it's what you
>> want.  You don't introduce a requirement to have the feature, but
>> take advantage of it if it is there.
>>
>> It may take everyone else a couple years to upgrade the compilers,
>> tools, libraries and kernel, and by that time any bugs introduced by
>> interacting with this feature will have been ironed out and their
>> patterns well known.
>>      
> Sorry, but this is pain not true. The 2.4->2.6 kernel cycle debacle has taught
> us that waiting long to 'iron out' the details has the following effects:
>
>   - developer pain
>   - user pain
>   - distro pain
>   - disconnect
>   - loss of developers, testers and users
>   - grave bugs discovered months (years ...) down the line
>   - untested features
>   - developer exhaustion
>
> It didnt work, trust me - and i've been around long enough to have suffered
> through the whole 2.5.x misery. Some of our worst ABIs come from that cycle as
> well.
>    

You're talking about a single project and comparing it to my argument 
about multiple independent projects.  In that case, I see no point in 
the discussion.  If you want to win the argument by strawman, you are 
welcome to do so.

> Sorry, but i really think you are really trying to rationalize a disadvantage
> here ...
>    

This could very well be true, but until someone comes forward with 
compelling numbers (as in, developers committed to working on the 
project, number of patches and total amount of code contribution), there 
is no point in having an argument, there really isn't anything to 
discuss other than opinion.  My opinion is you need a really strong 
justification to have a successful fork and I don't see that justification.

Zach
