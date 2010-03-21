Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0CUXnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 19:43:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63439 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0CUXnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 19:43:20 -0400
Message-ID: <4BA6AF13.2030602@codemonkey.ws>
Date: Sun, 21 Mar 2010 18:43:15 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
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
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 04:00 PM, Ingo Molnar wrote:
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
> My (clearly expressed) argument was that:
>
>      _a new guest-side demon is a transparent instrumentation non-starter_
>    

FWIW, there's no reason you couldn't consume a vmchannel port from 
within the kernel.  I don't think the code needs to be in the kernel and 
from a security PoV, that suggests that it should be in userspace IMHO.

But if you want to make a kernel thread, knock yourself out.  I have no 
objection to that from a qemu perspective.  I can't see why Avi would 
mind either.  I think it's papering around another problem (the kernel 
should control initrds IMHO) but that's a different topic.

Regards,

Anthony Liguori

