Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab1IAMlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:41:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:21903 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab1IAMlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,313,1312182000"; 
   d="scan'208";a="44665694"
Subject: Re: [PATCH] perf_event: fix Ming's Intel NHM/WSM/SNB uncore PMU
 patch
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>
In-Reply-To: <20110831124125.GA10443@quad>
References: <20110831124125.GA10443@quad>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 01 Sep 2011 20:38:42 +0800
Message-ID: <1314880722.2867.4.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 20:41 +0800, Stephane Eranian wrote:
> The following patch sits on top of Lin Ming's patch
> which adds support for Intel uncore PMU on NHM/WSM/SNB.
> The patch series was posted on LKML in July 2011.
> 
> The patches fixes:
>   - nhm_uncore_pmu_enable_all() to also enabled the fixed uncore counters
>   - uncore_pmu_add() to schedule for the actual max number of generic counters
>   - fixed the NHM/WSM vs. SNB MSRs for the fixed counter, they are swapped 
> 
> The patch adds the following improvement:
>   - add an event group validation function, to check if a group can ever be
>     schedule. This way, the behavior is consistent with core PMU event groups.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Can I merge this patch into my series with these change logs and your
signed-off-by?

Thanks,
Lin Ming

