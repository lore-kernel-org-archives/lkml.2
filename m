Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1CAAcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:32:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:33343 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab1CAAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:32:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,244,1297065600"; 
   d="scan'208";a="714380033"
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1298905892.5226.849.camel@laptop>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <1298884559.2428.10083.camel@twins>  <1298904994.2169.60.camel@localhost>
	 <1298905892.5226.849.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 08:32:23 +0800
Message-ID: <1298939543.4937.44.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 23:11 +0800, Peter Zijlstra wrote:
> On Mon, 2011-02-28 at 22:56 +0800, Lin Ming wrote:
> > @@ -740,13 +740,6 @@ static void intel_ds_init(void)
> >                         printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
> >                         x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
> >                         x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
> > -                       switch (boot_cpu_data.x86_model) {
> > -                       case 42: /* SandyBridge */
> > -                               x86_pmu.pebs_constraints = intel_snb_pebs_events;
> > -                               break;
> > -                       default:
> > -                               x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
> > -                       }
> >                         break; 
> 
> it looks like you lost the nhm table assignment

Ah, yes. Will update all in v3 patch.


