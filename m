Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336Ab2EQIGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:06:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:18212 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759952Ab2EQIGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:06:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144286475"
Message-ID: <4FB4B129.6030701@intel.com>
Date: Thu, 17 May 2012 16:04:57 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        fweisbec@gmail.com, jeremy@goop.org, riel@redhat.com, luto@mit.edu,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>     <1337072138-8323-7-git-send-email-alex.shi@intel.com>     <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>     <4FB2590C.1050303@intel.com> <1337092577.27694.45.camel@twins>    <1337093840.27694.56.camel@twins> <4FB34D49.1060809@intel.com>   <1337155239.27694.131.camel@twins> <4FB3ACD2.5010900@intel.com>  <1337202569.4281.13.camel@twins> <4FB449C1.2020603@intel.com> <1337220428.6724.87.camel@gandalf.stny.rr.com>
In-Reply-To: <1337220428.6724.87.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 10:07 AM, Steven Rostedt wrote:

> On Thu, 2012-05-17 at 08:43 +0800, Alex Shi wrote:
> 
>>> I've seem to have misplaced my cross-compiler set, so I've only compiled
>>> x86-64 for now.
>>
>>
>> Oh, I also need a cross-compiler for other archs. Thanks reminder!
> 
> Here:
> 
> http://kernel.org/pub/tools/crosstool/
> 
> Oh, and if you want to automate this. I attached a ktest.pl config that
> does it for you. I'll be pushing this config and others into a examples
> directory come the next merge window.
> 
> Ktest is located in the Linux tree under tools/testing/ktest/
> 
> You can run a bunch of cross compiles by doing:
> 
> ktest.pl crosstests.conf


It works fine. :)
But does ktest only do one kind of config testing?
How it do randconfig testing?

> 
> -- Steve
> 
> 
> 
> 


