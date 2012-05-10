Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab2EJFHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 01:07:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:23338 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab2EJFHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 01:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141231681"
Message-ID: <4FAB4CBF.3060604@intel.com>
Date: Thu, 10 May 2012 13:06:07 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mgorman@suse.de,
        npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] TLB flush optimization
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com> <1336489319.16236.43.camel@twins> <20120509234512.GA27196@tassilo.jf.intel.com>
In-Reply-To: <20120509234512.GA27196@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 07:45 AM, Andi Kleen wrote:

>> Have you tried what happens if you get rid of the funny multi-vector-ipi
>> scheme and use the generic smp_call functions?
> 
> Yes we did. It's much faster on larger systems.
> 
> But haven't sent the patch yet because wasn't sure if it wasn't slower
> on small systems.


Why you worried about the small system? are there some bad example there?

It should be helpful after multiple invlpg enabled. I like to take a
look this later. :)

> 
> -Andi
> 
> 


