Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2EKAfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:35:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:14096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab2EKAfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:35:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164711837"
Message-ID: <4FAC5E6E.8060903@intel.com>
Date: Fri, 11 May 2012 08:33:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/7] x86/tlb_info: get last level TLB entry number
 of CPU
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-3-git-send-email-alex.shi@intel.com> <20120510144321.GA32700@aftab.osrc.amd.com>
In-Reply-To: <20120510144321.GA32700@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +

>> +void intel_cpu_detect_tlb(struct cpuinfo_x86 *c)
> 
> cpu_detect_tlb() is __cpuinit and it calls into this one, maybe this
> whole facility should be __cpuinit/__cpuinitdata because its results
> land in the tlb_ll*_* arrays and all those functions and table can be
> thrown away then because they're not needed anymore.


Yes, you r right.
