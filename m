Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2FUF34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 01:29:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:19016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab2FUF3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 01:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183045450"
Message-ID: <4FE2B0C6.20709@intel.com>
Date: Thu, 21 Jun 2012 13:27:34 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        tony.luck@intel.com, luto@mit.edu, riel@redhat.com, avi@redhat.com,
        len.brown@intel.com, tj@kernel.org, akpm@linux-foundation.org,
        cl@gentwo.org, ak@linux.intel.com, jbeulich@suse.com,
        eric.dumazet@gmail.com, akinobu.mita@gmail.com, cpw@sgi.com,
        penberg@kernel.org, steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com,
        rientjes@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/8] x86 TLB flush range optimizing
References: <1339492005-20241-1-git-send-email-alex.shi@intel.com> <4FD8445E.9070502@intel.com>
In-Reply-To: <4FD8445E.9070502@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 03:42 PM, Alex Shi wrote:

> On 06/12/2012 05:06 PM, Alex Shi wrote:
> 
>> This version patches rebases on 3.5-rc2 kernel. It does some code clean up,
>> change patches sequency to make it looks more logical.
>> It also includes xen code change according to Jan Beulich's comments,
>> includes comments update of tlb flushing IPI according to PeterZ's suggestions.
>>
>> And Adding the flush_tlb_kernel_range support by invlpg.
>>
>> Thanks for all comments! and appreciate for more. :) 
> 
> 
> Any comments for this patch set. Specially on the 8th patch?


If no more comments, anyone like to pick up this patch set?

It does some performance and scalability help on x86 machine.

> 
>>
>> Alex Shi
>>
>> [PATCH v8 1/8] x86/tlb_info: get last level TLB entry number of CPU
>> [PATCH v8 2/8] x86/flush_tlb: try flush_tlb_single one by one in
>> [PATCH v8 3/8] x86/tlb: fall back to flush all when meet a THP large
>> [PATCH v8 4/8] x86/tlb: add tlb_flushall_shift for specific CPU
>> [PATCH v8 5/8] x86/tlb: add tlb_flushall_shift knob into debugfs
>> [PATCH v8 6/8] x86/tlb: enable tlb flush range support for generic
>> [PATCH v8 7/8] x86/tlb: replace INVALIDATE_TLB_VECTOR by
>> [PATCH v8 8/8] x86/tlb: do flush_tlb_kernel_range by 'invlpg'
> 
> 


