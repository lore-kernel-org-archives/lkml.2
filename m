Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2EKBAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 21:00:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:43895 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab2EKBAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 21:00:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151639955"
Message-ID: <4FAC6462.1070904@intel.com>
Date: Fri, 11 May 2012 08:59:14 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, borislav.petkov@amd.com, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/7] x86/tlb: add tlb_flushall_factor into sysfs for
 user testing/tuning
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-8-git-send-email-alex.shi@intel.com> <20120510151346.GD17472@kroah.com>
In-Reply-To: <20120510151346.GD17472@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Nowhere do you say this is x86 only, please fix that.


sure.

> 
> Yeah, another tunable that no one knows how to use.
> 
> Really, why is this here at all?  As others pointed out, this really
> looks like a debugging thing that almost no one will ever need, so
> please, put it in debugfs.


Ok.

> 
> 
> Do the #ifdef in the .h file, not the .c file please, no matter how you
> end up doing this (debugfs vs. sysfs.)


Ok.

> 
> thanks,
> 
> greg k-h
> 


