Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1GDLQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:16:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55495 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab1GDLQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:16:47 -0400
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 04 Jul 2011 13:16:32 +0200
Message-ID: <1309778192.3282.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> +#define MEM_STORE_DCU_HIT              (1ULL << 0)

I'm pretty sure that's not Dublin City University, but what is it?
Data-Cache-Unit? what does that mean, L1/L2 or also L3? 

> +#define MEM_STORE_STLB_HIT             (1ULL << 1)

What's an sTLB? I know iTLB and dTLB's but sTLBs I've not heard of yet.

> +#define MEM_STORE_LOCKED_ACCESS                (1ULL << 2) 

Presumably that's about LOCK'ed ops?

So now you're just tacking bits on the end without even attempting to
generalize/unify things, not charmed at all.

