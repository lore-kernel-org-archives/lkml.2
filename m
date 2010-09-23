Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0IWRhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab0IWRhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:37:48 -0400
Date: Thu, 23 Sep 2010 19:33:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 03/10] taskstats: Split fill_pid function
Message-ID: <20100923173314.GB26623@redhat.com>
References: <1285249681.1837.28.camel@holzheu-laptop> <1285250467.1837.80.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285250467.1837.80.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23, Michael Holzheu wrote:
>
> Subject: [PATCH] taskstats: Split fill_pid function
>
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
>
> Separate the finding of a task_struct by pid or tgid from filling the taskstats
> data. This makes the code more readable.

I think this is nice cleanup.

Oleg.

