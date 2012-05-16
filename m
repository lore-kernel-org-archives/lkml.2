Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967467Ab2EPM5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:57:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:54500 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966072Ab2EPM5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:57:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100742142"
Message-ID: <4FB3A435.9040809@intel.com>
Date: Wed, 16 May 2012 20:57:25 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Alex Shi <lkml.alex@gmail.com>, Nick Piggin <npiggin@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>  <1337072138-8323-7-git-send-email-alex.shi@intel.com>  <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>  <4FB2590C.1050303@intel.com> <1337092577.27694.45.camel@twins>  <1337093840.27694.56.camel@twins> <4FB34D49.1060809@intel.com>  <1337155239.27694.131.camel@twins> <1337155464.27694.132.camel@twins>  <4FB36B12.9000705@intel.com> <1337158712.27694.134.camel@twins>  <CAGjg+kGErUbt5JS7SLCGtUO_JKk0LtkpyM4JgFUsxHME53k=hQ@mail.gmail.com> <1337166253.27694.136.camel@twins>
In-Reply-To: <1337166253.27694.136.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 07:04 PM, Peter Zijlstra wrote:

> On Wed, 2012-05-16 at 18:58 +0800, Alex Shi wrote:
>> If someone can unify the common fields of mmu_gather, and
>> left private field for specific arch. it will be great and much
>> helpful. 
> 
> I've send you a link to a patch-set that does exactly that twice now.
> 
>   http://marc.info/?l=linux-mm&m=129952019004146&w=2


Thanks for resend. Actually, I had read many times above patch, but it's
still hard to catch some lines, maybe due to it can not apply on current
mm/memory.c that is due to your bit newer code 9547d01b on 2011-05-24.
or maybe I am too stupid. :)
