Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966994Ab2ERARi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:17:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:18393 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933558Ab2ERARg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:17:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="154233294"
Message-ID: <4FB594C3.9080706@intel.com>
Date: Fri, 18 May 2012 08:16:03 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, a.p.zijlstra@chello.nl,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: Re: [PATCH v6 0/7] tlb flush optimization on x86
References: <1337233375-840-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1337233375-840-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 01:42 PM, Alex Shi wrote:

> Thanks Peter Z, Peter Anvin, Nick Piggin, and many others' comments!
> 
> The main change of this version is on generic mmu_gather code.
> It was tested with arm cross-compiler.
> 
> Thanks Rongjie's testing, that show the real case performance gain.
> 
> Alex Shi
> 
> [PATCH v6 1/7] x86/tlb: unify TLB_FLUSH_ALL definition
> [PATCH v6 2/7] x86/tlb_info: get last level TLB entry number of CPU
> [PATCH v6 3/7] x86/flush_tlb: try flush_tlb_single one by one in
> [PATCH v6 4/7] x86/tlb: fall back to flush all when meet a THP large
> [PATCH v6 5/7] x86/tlb: add tlb_flushall_shift for specific CPU
> [PATCH v6 6/7] x86/tlb: enable tlb flush range support for generic
> [PATCH v6 7/7] x86/tlb: add tlb_flushall_shift knob into debugfs



Anyone like to pick up this patchset? It has benefit not only in theory,
but also in real word. And seems more modern CPU has more performance gain.

Thanks
Alex Shi
