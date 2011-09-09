Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab1IIN1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:27:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34238 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774Ab1IIN1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:27:06 -0400
Date: Fri, 9 Sep 2011 18:56:37 +0530
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
Message-ID: <20110909132637.GA8724@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110608163234.GA23031@linux.vnet.ibm.com>
 <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
 <20110610181719.GA30330@linux.vnet.ibm.com>
 <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
 <20110615053716.GA390@linux.vnet.ibm.com>
 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
 <20110907152009.GA3868@linux.vnet.ibm.com>
 <1315423342.11101.25.camel@twins>
 <20110908151433.GB6587@linux.vnet.ibm.com>
 <1315571462.26517.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1315571462.26517.9.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11090913-3270-0000-0000-000000139677
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-09 14:31:02]:

> > We have setup cgroups and their hard limits so that in theory they should
> > consume the entire capacity available on machine, leading to 0% idle time.
> > That's not what we see. A more detailed description of the setup and the problem
> > is here:
> > 
> > https://lkml.org/lkml/2011/6/7/352
> 
> That's frigging irrelevant isn't it? A patch should contain its own
> justification.

Agreed my bad. I was (wrongly) setting the problem context by posting
this in response to Paul's email where the problem was discussed.

> > One
> > possibility is to make the idle load balancer become aggressive in
> > pulling tasks across sched-domain boundaries i.e when a CPU becomes idle
> > (after a task got throttled) and invokes the idle load balancer, it
> > should try "harder" at pulling a task from far-off cpus (across
> > package/node boundaries)?
> 
> How about we just live with it?

I think we will, unless the load balancer can be improved (which seems unlikely 
to me :-()

- vatsa

