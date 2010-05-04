Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab0EDJUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:20:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab0EDJUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:20:05 -0400
Message-ID: <4BDFE6C2.2040601@redhat.com>
Date: Tue, 04 May 2010 12:20:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-17-git-send-email-joerg.roedel@amd.com> <4BD6DF7C.1090203@redhat.com> <20100503163221.GB28950@amd.com> <4BDFD295.7000702@redhat.com> <20100504091157.GC28950@amd.com>
In-Reply-To: <20100504091157.GC28950@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 12:11 PM, Roedel, Joerg wrote:
> On Tue, May 04, 2010 at 03:53:57AM -0400, Avi Kivity wrote:
>    
>> On 05/03/2010 07:32 PM, Joerg Roedel wrote:
>>      
>>> On Tue, Apr 27, 2010 at 03:58:36PM +0300, Avi Kivity wrote:
>>>
>>>        
>>>> So we probably need to upgrade gva_t to a u64.  Please send this as
>>>> a separate patch, and test on i386 hosts.
>>>>
>>>>          
>>> Are there _any_ regular tests of KVM on i386 hosts? For me this is
>>> terribly broken (also after I fixed the issue which gave me a
>>> VMEXIT_INVALID at the first vmrun).
>>>
>>>
>>>        
>> No, apart from the poor users.  I'll try to set something up using nsvm.
>>      
> Ok. I will post an initial fix for the VMEXIT_INVALID bug soon. Apart
> from that I get a lockdep warning when I try to start a guest. The guest
> actually boots if it is single-vcpu. SMP guests don't even boot through
> the BIOS for me.
>
>    

Strange.  i386 vs x86_64 shouldn't have that much effect!

-- 
error compiling committee.c: too many arguments to function

