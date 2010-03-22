Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0CVUpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab0CVUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:45:53 -0400
Message-ID: <4BA7D6DC.7060601@redhat.com>
Date: Mon, 22 Mar 2010 22:45:16 +0200
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
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B87A.8060104@codemonkey.ws> <20100322192259.GD21919@elte.hu> <4BA7C8C6.7080604@redhat.com> <20100322203518.GC18126@elte.hu>
In-Reply-To: <20100322203518.GC18126@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 10:35 PM, Ingo Molnar wrote:
>
>>> And your point is that such vcpus should be excluded from profiling just
>>> because they fall outside the Qemu/libvirt umbrella?
>>>
>>> That is a ridiculous position.
>>>
>>>        
>> Non-guest vcpus will not be able to provide Linux-style symbols.
>>      
> And why do you say that it makes no sense to profile them?
>    

It makes sense to profile them, but you don't need to contact their 
userspace tool for that.

> Also, why do you define 'guest vcpus' to be 'Qemu started guest vcpus'? If
> some other KVM using project (which you encouraged just a few mails ago)
> starts a vcpu we still want to be able to profile them.
>
>    

Maybe it should provide a mechanism for libvirt to list it.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

