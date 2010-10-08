Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab0JHQjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:39:40 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41859 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab0JHQji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:39:38 -0400
Date: Fri, 8 Oct 2010 22:09:32 +0530
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
Subject: Re: [RFC][PATCH 01/10] taskstats: Use real microsecond granularity
 for CPU times
Message-ID: <20101008163932.GG5327@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1285249681.1837.28.camel@holzheu-laptop>
 <1285250452.1837.78.camel@holzheu-laptop>
 <20101007050820.GP4195@balbir.in.ibm.com>
 <1286550492.1958.0.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1286550492.1958.0.camel@holzheu-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Holzheu <holzheu@linux.vnet.ibm.com> [2010-10-08 17:08:12]:

> On Thu, 2010-10-07 at 10:38 +0530, Balbir Singh wrote:
> > * Michael Holzheu <holzheu@linux.vnet.ibm.com> [2010-09-23 16:00:52]:
> > 
> > > Subject: [PATCH] taskstats: Use real microsecond granularity for CPU times
> > > 
> > > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > > 
> > > The taskstats interface uses microsecond granularity for the user and
> > > system time values. The conversion from cputime to the taskstats values
> > > uses the cputime_to_msecs primitive which effectively limits the 
> > > granularity to milliseconds. Add the cputime_to_usecs primitive for
> > > architectures that have better, more precise CPU time values. Remove
> > > cputime_to_msecs primitive because there is no more user left.
> > > 
> > > Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > Looks good to me.
> 
> Can I take that as an Acked-by?
>

Certainly

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
