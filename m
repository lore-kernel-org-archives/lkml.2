Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2FGU4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:56:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:32487 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab2FGU4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:56:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109257287"
Subject: Re: [patch] irq: use config_enabled(SMP) checks to cleanup
 irq_set_affinity() for UP
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joerg.roedel@amd.com, paul.gortmaker@windriver.com,
        Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 07 Jun 2012 13:56:23 -0700
In-Reply-To: <CAE9FiQX=UGETwk+j1YQzGSJQsvuTWBN1LzL_BbF2r5qS-EFG7Q@mail.gmail.com>
References: <20120509093001.GD8585@gmail.com>
	 <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
	 <1336589196-14498-2-git-send-email-suresh.b.siddha@intel.com>
	 <1336593505.4634.11.camel@sbsiddha-desk.sc.intel.com>
	 <20120510075031.GC28395@gmail.com>
	 <1339025388.28766.70.camel@sbsiddha-desk.sc.intel.com>
	 <CAE9FiQXh82++LRJnFbYXAVQmCPM00M8HO0KQ523WYD+rZKvt2w@mail.gmail.com>
	 <1339101083.28766.80.camel@sbsiddha-desk.sc.intel.com>
	 <CAE9FiQX=UGETwk+j1YQzGSJQsvuTWBN1LzL_BbF2r5qS-EFG7Q@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339102584.28766.94.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 13:36 -0700, Yinghai Lu wrote:
> On Thu, Jun 7, 2012 at 1:31 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> >>
> >> can you just use
> >> if (nr_cpu_ids > 1)
> >> checking instead
> >> if config_enabled(CONFIG_SMP)
> >
> > Idea is to not have any extra runtime checks if CONFIG_SMP is enabled
> > and which is when all the smp affinity routines are used/invoked.
> 
> then could use
> if (NR_CPUS > 1)

What is the problem with using config_enabled(CONFIG_SMP)? People
looking for "CONFIG_SMP" can easily identify the dependency.

thanks,
suresh


