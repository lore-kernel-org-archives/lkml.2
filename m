Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab1EYWB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 18:01:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:50654 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab1EYWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 18:01:23 -0400
Date: Thu, 26 May 2011 00:01:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        david.woodhouse@intel.com, akpm@linux-foundation.org, hpa@zytor.com,
        hpa@linux.intel.com, allen.m.kay@intel.com, suresh.b.siddha@intel.com,
        rajesh.sankaran@intel.com, asit.k.mallick@intel.com,
        kent.liu@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v4] x86, vt-d: enable x2apic opt out
In-Reply-To: <20110525205843.GC28397@elte.hu>
Message-ID: <alpine.LFD.2.02.1105252359460.3078@ionos>
References: <1306341418-10645-1-git-send-email-youquan.song@intel.com> <20110525205843.GC28397@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Ingo Molnar wrote:

> 
> * Youquan Song <youquan.song@intel.com> wrote:
> 
> > New version of VT-d2 specification 
> > (http://download.intel.com/technology 
> > /computing/vptech/Intel(r)_VT_for_Direct_IO.pdf) includes a new 
> > feature that provide firmware a way to request system software to 
> > opt out of enable x2APIC mode. DMAR ACPI table newly define flags.1 
> > bit: x2APIC_OPT_OUT which is set to request System software opt out 
> > xAPIC mode if flags.0 bit:INTR_REMAP is also set.
> 
> So why isnt the x2apic disabled in the CPUID? That's the canonical 
> way to unsupport a particular non-working CPU hw feature.

Because some committee decided to make it an ACPI feature. That's
broken by design, but you can't change the stupid spec retroactively.

Thanks,

	tglx
