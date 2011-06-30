Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1F3OJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:09:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59463 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1F3OJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:09:49 -0400
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Jun 2011 16:08:23 +0200
Message-ID: <1309442903.12449.55.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 08:09 +0000, Lin Ming wrote:
> +static struct pmu uncore_pmu = {

	.task_ctx_nr = perf_invalid_context,

> +       .event_init     = uncore_pmu_event_init,
> +       .add            = uncore_pmu_add,
> +       .del            = uncore_pmu_del,
> +       .start          = uncore_pmu_start,
> +       .stop           = uncore_pmu_stop,
> +       .read           = uncore_pmu_read,
> +}; 


