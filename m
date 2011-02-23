Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab1BWD3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:29:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:40616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab1BWD3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:29:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,210,1297065600"; 
   d="scan'208";a="890305484"
Message-ID: <4D647F1D.2000307@linux.intel.com>
Date: Wed, 23 Feb 2011 11:29:33 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Shaohui Zheng <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org,
        Andi Kleen <ak@linux.intel.com>, dave@linux.vnet.ibm.com,
        Greg Kroah-Hartman <gregkh@suse.de>, yang.z.zhang@intel.com,
        "You, Yongkang" <yongkang.you@intel.com>
Subject: Re: [0/7, v9] NUMA Hotplug Emulator (v9)
References: <20101210073119.156388875@intel.com> <alpine.DEB.2.00.1102221429030.31758@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1102221429030.31758@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohui is out of position recently. Include Yang Zhang and Yongkang You in 
this loop, who are Shaohui's backup.

David Rientjes wrote:
> On Fri, 10 Dec 2010, shaohui.zheng@intel.com wrote:
> 
>> v9:
>>
>> Solve the bug reported by Eric B Munson, check the return value of cpu_down when do
>>  CPU release.
>>
>> Solve the conflicts with Tejun Heo' Unificaton NUMA code, re-work patch 5 based on his
>> patch.
>>
>> Some small changes on debugfs per-node add_memory interface.
>>
> 
> Hi Shaohui,
> 
> Tejun's NUMA unification work has been merged into x86/mm, so I think it 
> would possible to rebase your hotplug emulator patchset on top of it 
> without too many conflicts now.
> 
> It should probably be based on x86/mm from 
> http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
