Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1GVLhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 07:37:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47409 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1GVLhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 07:37:32 -0400
Subject: Re: [patch 11/18] sched: prevent interactions with throttled
 entities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <20110722112601.GC20315@linux.vnet.ibm.com>
References: <20110721164325.231521704@google.com>
	 <20110721184757.777916795@google.com>
	 <20110722112601.GC20315@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Jul 2011 13:37:10 +0200
Message-ID: <1311334630.27400.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 16:56 +0530, Kamalesh Babulal wrote:
> > @@ -2630,8 +2711,13 @@ static void update_shares(int cpu)
> >       struct rq *rq = cpu_rq(cpu);
> > 
> >       rcu_read_lock();
> > -     for_each_leaf_cfs_rq(rq, cfs_rq)
> > +     for_each_leaf_cfs_rq(rq, cfs_rq) {
> 
> this hunk fails to apply over the latest tip, due to the comments
> introduced by 9763b67fb9f3050.

please trim your replies.
