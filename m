Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab0KOSAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:00:37 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:57423 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab0KOSAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:00:36 -0500
Date: Mon, 15 Nov 2010 19:00:31 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC][PATCH v2 5/7] taskstats: Improve cumulative CPU time
 accounting
Message-ID: <20101115190031.5a50e760@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1289843517.2109.521.camel@laptop>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	<20101111170815.404670062@linux.vnet.ibm.com>
	<20101113183810.GA9021@redhat.com>
	<20101115165521.21baac60@mschwide.boeblingen.de.ibm.com>
	<1289837036.2109.501.camel@laptop>
	<20101115184910.549a828b@mschwide.boeblingen.de.ibm.com>
	<1289843517.2109.521.camel@laptop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 18:51:57 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2010-11-15 at 18:49 +0100, Martin Schwidefsky wrote:
> > > To what purpose? 
> >  
> > Is that a trick question? Why do we have tools like "top"? Or process
> > accounting? The point is that the quality of the numbers we get right
> > now is rather bad, the overhead of scanning /proc is horrendous and
> > the 10ms granularity is rather coarse. 
> 
> But you're not just replacing top, you're adding all kinds of new
> accounting crap all over the place.

We DO replace top. Patch #7 of 7.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

