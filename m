Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1B1PKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:10:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:57610 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1B1PKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:10:02 -0500
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1298904994.2169.60.camel@localhost>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <1298884559.2428.10083.camel@twins>  <1298904994.2169.60.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 16:11:32 +0100
Message-ID: <1298905892.5226.849.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 22:56 +0800, Lin Ming wrote:
> @@ -740,13 +740,6 @@ static void intel_ds_init(void)
>                         printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
>                         x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
>                         x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
> -                       switch (boot_cpu_data.x86_model) {
> -                       case 42: /* SandyBridge */
> -                               x86_pmu.pebs_constraints = intel_snb_pebs_events;
> -                               break;
> -                       default:
> -                               x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
> -                       }
>                         break; 

it looks like you lost the nhm table assignment


