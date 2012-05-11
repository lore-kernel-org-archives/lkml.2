Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab2EKAj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:39:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:58669 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab2EKAj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:39:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142570192"
Message-ID: <4FAC5F68.1050100@intel.com>
Date: Fri, 11 May 2012 08:38:00 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/7] x86/tlb_info: get last level TLB entry number
 of CPU
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-3-git-send-email-alex.shi@intel.com> <20120510155802.GF32700@aftab.osrc.amd.com>
In-Reply-To: <20120510155802.GF32700@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> Btw, we're only using the tlb_ll[id]_4k arrays in flush_tlb_range and do
> not touch 2m or 4m entries. Do you have any future plans for those or
> can they simply be removed?


I can not do full testing on all CPU, since no much machine in hands. It
maybe useful for AMD or other CPUs.

> 
> Besides, those arrays contain only the entries count per TLB size. Maybe
> turn them into simple variables?


Similar reason to keep current mode, if array doesn't increase data
size. and left extend capacity.

> 
> Thanks.
> 


