Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0CXGnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 02:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab0CXGnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 02:43:13 -0400
Message-ID: <4BA9B454.5090908@redhat.com>
Date: Wed, 24 Mar 2010 08:42:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu>	<4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu>	<4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu>	<4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws>	<20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com>	<20100323182153.GA14800@8bytes.org> <87hbo6fgpy.fsf@basil.nowhere.org>
In-Reply-To: <87hbo6fgpy.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 07:09 AM, Andi Kleen wrote:
> Joerg Roedel<joro@8bytes.org>  writes:
>    
>> Sidenote: I really think we should come to a conclusion about the
>>            concept. KVM integration into perf is very useful feature to
>> 	  analyze virtualization workloads.
>>      
> Agreed. I especially would like to see instruction/branch tracing
> working this way.  This would a lot of the benefits of a simulator on
> a real CPU.
>    

If you're profiling a single guest it makes more sense to do this from 
inside the guest - you can profile userspace as well as the kernel.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

