Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1DRT76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:59:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:26316 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1DRT75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:59:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,234,1301900400"; 
   d="scan'208";a="911262103"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: ming.m.lin@intel.com, peterz@infradead.org, mingo@elte.hu,
        eranian@gmail.com, akpm@linux-foundation.org, fweisbec@gmail.com
Subject: PING Re: [PATCH] perf: Add missing user space support for config1/config2
References: <1302652370-3479-1-git-send-email-andi@firstfloor.org>
Date: Mon, 18 Apr 2011 12:59:22 -0700
In-Reply-To: <1302652370-3479-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Tue, 12 Apr 2011 16:52:50 -0700")
Message-ID: <m2bp039vqd.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> The offcore_msr perf kernel code was merged into 2.6.39-rc*,
> but the user space bits were not. This made it impossible
> to set the extra mask and actually do the OFFCORE profiling

PING. Can someone review/merge this patch please?
Without it the offcore profiling support in .39 is unusable.

Thanks,
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
