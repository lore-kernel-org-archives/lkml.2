Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2EIB7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 21:59:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:34981 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290Ab2EIB7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 21:59:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163721844"
Message-ID: <4FA9CF2C.7030104@intel.com>
Date: Wed, 09 May 2012 09:58:04 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] TLB flush optimization
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com> <1336489319.16236.43.camel@twins>
In-Reply-To: <1336489319.16236.43.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> [PATCH v3 1/7] x86/tlb_info: get last level TLB entry number of CPU
>> [PATCH v3 2/7] x86/flush_tlb: try flush_tlb_single one by one in
>> [PATCH v3 3/7] x86/tlb: fall back to flush all when meet a THP large
>> [PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific CPUs
>> [PATCH v3 5/7] x86/tlb: remove comments for tlb_flush_range
>> [PATCH v3 6/7] x86/tlb: optimizing flush_tlb_mm
>> [PATCH v3 7/7] x86/tlb: add tlb_flushall_factor into sysfs for user
> 
> Have you tried what happens if you get rid of the funny multi-vector-ipi
> scheme and use the generic smp_call functions?


Not yet.
