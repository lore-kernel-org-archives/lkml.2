Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1IWW2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:28:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:56194 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1IWW2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:28:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,432,1312182000"; 
   d="scan'208";a="66978260"
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
	<1316778523.9084.17.camel@twins> <20110923122014.GP6063@erda.amd.com>
Date: Fri, 23 Sep 2011 15:28:49 -0700
In-Reply-To: <20110923122014.GP6063@erda.amd.com> (Robert Richter's message of
	"Fri, 23 Sep 2011 14:20:14 +0200")
Message-ID: <m2hb42ki5a.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter <robert.richter@amd.com> writes:
>
> I think we could extend perf report to parse also ibs samples. The
> only thing we need for it should be the pmu name/type mapping in the
> perf.data header and the pmu type in the sample. See my comment on
> Stephane's patch '[PATCH] perf: make perf.data more self-descriptive
> (v5)'.

I would like to have a similar user tool for Intel PEBS data.

I have some hacks currently to dump more data from the PEBS record and
it's useful for some situations. I was actually thinking of adapting
Robert's tool, but integrating it into other tools is fine too.

Sometimes a "perf print-samples" to print individual samples
would be useful too  (it's already possible with -R, but very unfriendly
without post processing)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
