Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2EKAsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:48:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:50361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab2EKAst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151637825"
Message-ID: <4FAC619B.1040305@intel.com>
Date: Fri, 11 May 2012 08:47:23 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>  <1336626013-28413-6-git-send-email-alex.shi@intel.com> <1336642543.2527.81.camel@twins>
In-Reply-To: <1336642543.2527.81.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 05:35 PM, Peter Zijlstra wrote:

> On Thu, 2012-05-10 at 13:00 +0800, Alex Shi wrote:
>> +       case 0x60f: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
>> +               tlb_flushall_factor = -1;
>> +               break; 
> 
> Why not the 45nm Core2 chips?


Uh, I haven't this CPU in hands.
but the experience show same micro-architecture CPU has same results.
So, I am going to add it.

> 
> And where's the Core (model 14) "Yonah" gone?


no this type CPU in hands.

> 
> 
> 


