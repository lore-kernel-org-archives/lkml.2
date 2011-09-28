Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1I1OvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:51:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57327 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1I1Ou7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:50:59 -0400
Date: Wed, 28 Sep 2011 19:57:36 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Venki Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110928142735.GG8593@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
 <20110928043427.GI4357@linux.vnet.ibm.com>
 <20110928141701.GF8593@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110928141701.GF8593@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2011-09-28 19:47:01]:

> * Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2011-09-28 10:04:27]:
> 
> > > Especially with higher number of logical CPUs. Likely cleaner way is to clear
> > > first_pick, second_pick on idle instead of clearing on tickless.
> > 
> > I think I tried that (cleared first/second_pick_cpu in
> > nohz_kick_needed() upon idle) but didn't get the best results.

which perhaps was beause I was relying on idle_at_tick (which can be
stale information as Suresh pointed out).

- vatsa
