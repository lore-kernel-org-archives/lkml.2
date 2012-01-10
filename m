Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2AJQvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:51:53 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:53065 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab2AJQvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:51:52 -0500
Date: Tue, 10 Jan 2012 22:21:29 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Youquan Song <youquan.song@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        arjan@linux.intel.com, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120110165129.GC17432@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
 <1326103578.2442.50.camel@twins>
 <20120110001445.GA20542@linux-youquan.bj.intel.com>
 <1326107156.2442.59.camel@twins>
 <20120110055856.GA23741@linux-youquan.bj.intel.com>
 <1326153163.2366.7.camel@sbsiddha-mobl2>
 <20120110165426.GA20681@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120110165426.GA20681@linux-youquan.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12011016-4790-0000-0000-000000C81DC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Youquan Song <youquan.song@intel.com> [2012-01-10 11:54:26]:

> 
> > Youquan, As far as I know both the
> > sched_smt_power_savings/sched_mc_power_savings are broken for atleast an
> > year.
> > 
> > Have you checked the state of 'sched_mc_power_savings' to see if it is
> > working or gets addressed with your proposed patches?
> Thanks Suresh!
> 
> We have verified that sched_mc_power_savings works well in mainline and
> -tip tree, only sched_smt_power_savings broken.

Hi Suresh,

My testing also shows that sched_mc works find and only sched_smt
suffers from the group capacity problem at the core level.

--Vaidy

