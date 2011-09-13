Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab1IMSfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:35:14 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45829 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab1IMSfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:35:12 -0400
Date: Wed, 14 Sep 2011 00:05:02 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110913183502.GP11100@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110913050306.GB7254@linux.vnet.ibm.com>
 <1315906788.575.3.camel@twins>
 <20110913112852.GE7254@linux.vnet.ibm.com>
 <1315922848.5977.11.camel@twins>
 <20110913162119.GA3045@linux.vnet.ibm.com>
 <1315931775.5977.29.camel@twins>
 <20110913175425.GB3062@linux.vnet.ibm.com>
 <1315937995.4226.9.camel@twins>
 <20110913182841.GO11100@linux.vnet.ibm.com>
 <1315938646.4226.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1315938646.4226.12.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11091318-8974-0000-0000-0000001FED68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 20:30:46]:

> On Tue, 2011-09-13 at 23:58 +0530, Srivatsa Vaddagiri wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 20:19:55]:
> > 
> > > On Tue, 2011-09-13 at 23:24 +0530, Srivatsa Vaddagiri wrote:
> > > > We saw considerably high migration count on latest tip compared to
> > > > previous kernels. Kamalesh, can you please post the migration count
> > > > data? 
> > > 
> > > Hrmm, yes this looks horrid.. even without cgroup crap, something's funny.
> > 
> > Yes ..we could visualize that very much in top o/p .. A task's cpu would keep 
> > changing *every* screen refresh (refreshed every 0.5 sec that too!).
> > 
> > We didn't see that with older kernels ..Kamalesh is planning to do a
> > git bisect and see which commit lead to this "mad" hopping ..
> 
> Awesome, thanks! Btw, what is 'older'? 3.0?

We went back all the way upto 2.6.32! I think 2.6.38 and 2.6.39 were
pretty stable ..I don't have the migration count data with me readily. I
will let Kamalesh post that info soon.

- vatsa

