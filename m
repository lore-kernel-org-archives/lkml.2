Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab0JHPIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:08:17 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:54421 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0JHPIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:08:16 -0400
Subject: Re: [RFC][PATCH 01/10] taskstats: Use real microsecond granularity
 for CPU times
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: balbir@linux.vnet.ibm.com
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
In-Reply-To: <20101007050820.GP4195@balbir.in.ibm.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
	 <1285250452.1837.78.camel@holzheu-laptop>
	 <20101007050820.GP4195@balbir.in.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Fri, 08 Oct 2010 17:08:12 +0200
Message-ID: <1286550492.1958.0.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 10:38 +0530, Balbir Singh wrote:
> * Michael Holzheu <holzheu@linux.vnet.ibm.com> [2010-09-23 16:00:52]:
> 
> > Subject: [PATCH] taskstats: Use real microsecond granularity for CPU times
> > 
> > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > The taskstats interface uses microsecond granularity for the user and
> > system time values. The conversion from cputime to the taskstats values
> > uses the cputime_to_msecs primitive which effectively limits the 
> > granularity to milliseconds. Add the cputime_to_usecs primitive for
> > architectures that have better, more precise CPU time values. Remove
> > cputime_to_msecs primitive because there is no more user left.
> > 
> > Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Looks good to me.

Can I take that as an Acked-by?

Michael


