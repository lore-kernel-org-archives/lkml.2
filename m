Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab1JFR2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758Ab1JFR2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:28:07 -0400
Date: Thu, 6 Oct 2011 13:27:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org
Subject: Re: [patch v2 1/2] sched: Use resched IPI to kick off the nohz idle
 balance
Message-ID: <20111006172731.GA31781@redhat.com>
References: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 03:09:00PM -0700, Suresh Siddha wrote:
[..]
> 
>    [ This issue is present from 2.6.35+ kernels, but marking it -stable
>      only from v3.0+ as the proposed fix depends on the scheduler_ipi()
>      that is introduced recently. ]
> 

Hi Suresh,

Are you planning to fix this issue for older kernels too? I am wondering
how to go about fixing it there.

Thanks
Vivek
