Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab2EKMvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:51:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:63691 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab2EKMvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164938465"
Message-ID: <4FAD0B3A.4060705@intel.com>
Date: Fri, 11 May 2012 20:51:06 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/7] x86/tlb: add tlb flush all factor for specific
 CPU
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>  <1336626013-28413-6-git-send-email-alex.shi@intel.com>  <1336642715.2527.84.camel@twins> <4FAC621D.2020704@intel.com>  <1336727058.2527.144.camel@twins> <1336727094.2527.145.camel@twins>
In-Reply-To: <1336727094.2527.145.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 05:04 PM, Peter Zijlstra wrote:

> On Fri, 2012-05-11 at 11:04 +0200, Peter Zijlstra wrote:
> 
>>> NO, the first judgement is from CPU. But second '-1' is may from user
>>> setting in sysfs.
>>
>> Then you're doing it wrong. Don't allow setting the sysfs variable if !
>> cpu_has_invlpg.
> 
> Better yet, don't create the sysfs file at all in that case.


Yes, true.
