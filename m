Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0JKIb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:31:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40388 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab0JKIbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:31:24 -0400
Date: Mon, 11 Oct 2010 14:01:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 03/10] taskstats: Split fill_pid function
Message-ID: <20101011083117.GB17223@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1285249681.1837.28.camel@holzheu-laptop>
 <1285250467.1837.80.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1285250467.1837.80.camel@holzheu-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Holzheu <holzheu@linux.vnet.ibm.com> [2010-09-23 16:01:07]:

> Subject: [PATCH] taskstats: Split fill_pid function
> 
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Separate the finding of a task_struct by pid or tgid from filling the taskstats
> data. This makes the code more readable.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
 
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
