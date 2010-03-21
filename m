Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0CUVo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:44:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0CUVo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:44:57 -0400
Message-ID: <4BA69344.40504@redhat.com>
Date: Sun, 21 Mar 2010 23:44:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Antoine Martin <antoine@nagafix.co.uk>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
References: <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA674F1.6070603@nagafix.co.uk> <20100321195903.GA29490@elte.hu> <4BA67D0B.9030705@redhat.com> <20100321210011.GD30194@elte.hu>
In-Reply-To: <20100321210011.GD30194@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 11:00 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/21/2010 09:59 PM, Ingo Molnar wrote:
>>      
>>> Frankly, i was surprised (and taken slightly off base) by both Avi and Anthony
>>> suggesting such a clearly inferior "add a demon to the guest space" solution.
>>> It's a usability and deployment non-starter.
>>>        
>> It's only clearly inferior if you ignore every consideration against it.
>> It's definitely not a deployment non-starter, see the tons of daemons that
>> come with any Linux system. [...]
>>      
> Avi, please dont put arguments into my mouth that i never made.
>    

Sorry, that was not the intent.  I meant that putting things into the 
kernel have disadvantages that must be considered.

> My (clearly expressed) argument was that:
>
>      _a new guest-side demon is a transparent instrumentation non-starter_
>
> What is so hard to understand about that simple concept? Instrumentation is
> good if it's as transparent as possible.
>
> Of course lots of other features can be done via a new user-space package ...
>    

I believe you can deploy this daemon via a (default) package, without 
any hassle to users.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

