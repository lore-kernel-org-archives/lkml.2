Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1CPP3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:29:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:35544 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab1CPP26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:28:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,194,1299484800"; 
   d="scan'208";a="667918372"
Date: Wed, 16 Mar 2011 08:27:57 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: [PATCH] oprofile: Allow setting EDGE/INV/CMASK for Intel counter
 events
Message-ID: <20110316152757.GA12845@tassilo.jf.intel.com>
References: <1299870748-13319-1-git-send-email-andi@firstfloor.org>
 <20110316150450.GO31407@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316150450.GO31407@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would like to write the actual value back so that userland may read
> it:
> 
> 	counter_config->extra &= (ARCH_PERFMON_EVENTSEL_INV|
>                          ARCH_PERFMON_EVENTSEL_EDGE|
>                          ARCH_PERFMON_EVENTSEL_CMASK);
> 	val |= counter_config->extra;
> 
> The value will not be updated emmediately but at least after profiling
> was started.

Okay.

> 
> As an alternative, maybe we better put this extra bits in the
> unit_mask, e.g. in bits [31:16] of the unit mask for bits [31:16] of
> PerfEvtSel? Then, we simply could use the current userland to set it
> up.

We can't anyways, it doesn't support it.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
