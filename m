Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1GALIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:08:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52895 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab1GALIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:08:19 -0400
Date: Fri, 1 Jul 2011 13:08:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf: Intel uncore pmu counting support
Message-ID: <20110701110810.GC20990@elte.hu>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> Hi, all
> 
> I posted uncore patches months ago, but it was pended due to an uncore
> interrupt problem.
> 
> This series are cut to support uncore pmu counting only.
> So uncore interrupt handling is not needed.
> 
> The uncore pmu type is allocated dynamically and exported via sysfs.
> $ cat /sys/bus/event_source/devices/uncore/type
> 6
> 
> You can count uncore raw events as below,
> $ perf stat -e uncore:r0101 ls
> 
> It reads uncore pmu type id from sysfs to setup perf_event_attr::type.
> 
> Comments are appreciated.

Could you please list the most useful hw events that Intel would like 
users to be able to measure via the uncore PMU, and which are not 
available via the offcore PMU?

Thanks,

	Ingo
