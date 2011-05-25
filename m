Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1EYU65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:58:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab1EYU64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:58:56 -0400
Date: Wed, 25 May 2011 22:58:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, david.woodhouse@intel.com,
        akpm@linux-foundation.org, tglx@linutronix.de, hpa@zytor.com,
        hpa@linux.intel.com, allen.m.kay@intel.com, suresh.b.siddha@intel.com,
        rajesh.sankaran@intel.com, asit.k.mallick@intel.com,
        kent.liu@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v4] x86, vt-d: enable x2apic opt out
Message-ID: <20110525205843.GC28397@elte.hu>
References: <1306341418-10645-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306341418-10645-1-git-send-email-youquan.song@intel.com>
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


* Youquan Song <youquan.song@intel.com> wrote:

> New version of VT-d2 specification 
> (http://download.intel.com/technology 
> /computing/vptech/Intel(r)_VT_for_Direct_IO.pdf) includes a new 
> feature that provide firmware a way to request system software to 
> opt out of enable x2APIC mode. DMAR ACPI table newly define flags.1 
> bit: x2APIC_OPT_OUT which is set to request System software opt out 
> xAPIC mode if flags.0 bit:INTR_REMAP is also set.

So why isnt the x2apic disabled in the CPUID? That's the canonical 
way to unsupport a particular non-working CPU hw feature.

Thanks,

	Ingo
