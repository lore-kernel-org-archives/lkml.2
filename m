Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1DRUBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:01:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:47907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab1DRUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:01:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,234,1301900400"; 
   d="scan'208";a="421437703"
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] perf, x86: Use ALTERNATIVE() to check for X86_FEATURE_PERFCTR_CORE
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
	<1302913676-14352-4-git-send-email-robert.richter@amd.com>
Date: Mon, 18 Apr 2011 13:00:57 -0700
In-Reply-To: <1302913676-14352-4-git-send-email-robert.richter@amd.com>
	(Robert Richter's message of "Sat, 16 Apr 2011 02:27:55 +0200")
Message-ID: <m27har9vnq.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter <robert.richter@amd.com> writes:

> Using ALTERNATIVE() when checking for X86_FEATURE_PERFCTR_CORE avoids
> an extra pointer chase and data cache hit.

Is that really a performance critical path?

Seems more like unnecessary obfuscation to me.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
