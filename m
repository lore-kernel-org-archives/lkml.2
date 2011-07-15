Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1GOOs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:48:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47843 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1GOOs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:48:26 -0400
MIME-Version: 1.0
In-Reply-To: <1310740503-15608-3-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	<1310740503-15608-3-git-send-email-ming.m.lin@intel.com>
Date: Fri, 15 Jul 2011 22:48:25 +0800
Message-ID: <CAF1ivSZk1OKK5NSAeebxsTHMbgzWmrTRC_r6jeBkawJ_QUoAUA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: Lin Ming <minggr@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:34 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> +
> +#define UNCORE_PMU_NUM_GENERIC_EVENTS 1
> +
> +static struct pmu_event uncore_events[UNCORE_PMU_NUM_GENERIC_EVENTS] = {
> +       {"cycle", 0xffff, },
> +};

Sorry, hard code 0xffff should be replaced with UNCORE_FIXED_EVENT
The uncore fixed event is used to count uncore cycle.

We can add other general events for uncore pmu later.

Lin Ming
