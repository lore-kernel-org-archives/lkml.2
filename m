Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728Ab0CPKlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:41:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab0CPKla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:41:30 -0400
Message-ID: <4B9F603B.4080004@redhat.com>
Date: Tue, 16 Mar 2010 12:40:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <1268717232.2813.36.camel@localhost> <4B9F19F7.6000309@redhat.com> <20100316072449.GB11881@elte.hu> <4B9F4D74.4090403@redhat.com> <20100316095336.GI7961@elte.hu> <4B9F59DE.1060008@redhat.com> <20100316102052.GC10069@elte.hu>
In-Reply-To: <20100316102052.GC10069@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 12:20 PM, Ingo Molnar wrote:
>>>>
>>>> The symbol server's client can certainly access the bits through vmchannel.
>>>>          
>>> Ok, that would work i suspect.
>>>
>>> Would be nice to have the symbol server in tools/perf/ and also make it easy
>>> to add it to the initrd via a .config switch or so.
>>>
>>> That would have basically all of the advantages of being built into the kernel
>>> (availability, configurability, transparency, hackability), while having all
>>> the advantages of a user-space approach as well (flexibility, extensibility,
>>> robustness, ease of maintenance, etc.).
>>>        
>> Note, I am not advocating building the vmchannel client into the host
>> kernel. [...]
>>      
> Neither am i. What i suggested was a user-space binary/executable built in
> tools/perf and put into the initrd.
>    

I'm confused - initrd seems to be guest-side.  I was talking about the 
host side.

For the guest, placing the symbol server in tools/ is reasonable.

-- 
error compiling committee.c: too many arguments to function

