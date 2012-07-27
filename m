Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2G0BuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:50:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:53060 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2G0BuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:50:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="172011217"
Message-ID: <5011F3CB.2080707@intel.com>
Date: Fri, 27 Jul 2012 09:50:03 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [PATCH 2/2] sched: fix a logical error in select_task_rq_fair
References: <1343280446-24019-1-git-send-email-alex.shi@intel.com>  <1343280446-24019-2-git-send-email-alex.shi@intel.com> <1343290631.26034.86.camel@twins> <501109DD.7020501@intel.com>
In-Reply-To: <501109DD.7020501@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> In that case aren't we covering up a bug in find_idlest_group(), it
>> appears to have returned a group that isn't eligible to be idlest.
> 
> 
> If it is possible happening in sched_domain rebuilding?
> I didn't meet this bug. Just guess.


Even so, it is not related with this patch.
So, Thanks for clarify!  and forget this patch.

> 
>>
>>
> 
> 


