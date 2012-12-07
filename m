Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422882Ab2LGAfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:35:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:53961 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab2LGAfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:35:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,233,1355126400"; 
   d="scan'208";a="230090218"
Message-ID: <50C13960.5010901@intel.com>
Date: Fri, 07 Dec 2012 08:33:36 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <lkml.alex@gmail.com>
CC: npiggin@kernel.dk, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/4] sched: fork/exec/wake clean up
References: <1354542848-29638-1-git-send-email-alex.shi@intel.com> <CAGjg+kE9dFSfnridN_5ngtuC1r5rbnkLVfyqkdTwWCE0LOG4OQ@mail.gmail.com>
In-Reply-To: <CAGjg+kE9dFSfnridN_5ngtuC1r5rbnkLVfyqkdTwWCE0LOG4OQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 03:09 PM, Alex Shi wrote:
> On Mon, Dec 3, 2012 at 9:54 PM, Alex Shi <alex.shi@intel.com> wrote:
>> This patchset try to clean up select_task_rq_fair which used for
>> fork/exec/wake scheduling.
>>
>> With this patchset, our system NHM EX and SNB EP 4 socket machine
>> has 10% hackbench performance increase.
> 
> Any comments for this patchset?

Nick & Ingo:
Would you like to give some comments for this?


CC to more experts :)

Thanks!
Alex
>>
>> Regards
>> Alex
>>
>> [PATCH 01/4] sched: select_task_rq_fair clean up
>> [PATCH 02/4] sched: fix find_idlest_group mess logical
>> [PATCH 03/4] sched: don't need go to smaller sched domain
>> [PATCH 04/4] sched: remove domain iterations in fork/exec/wake
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

