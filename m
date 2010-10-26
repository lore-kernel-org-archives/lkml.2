Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab0JZPqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:46:48 -0400
Received: from www.tglx.de ([62.245.132.106]:46979 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab0JZPqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:46:47 -0400
Date: Tue, 26 Oct 2010 17:46:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
In-Reply-To: <1288103930.15336.321.camel@twins>
Message-ID: <alpine.LFD.2.00.1010261745260.3115@localhost6.localdomain6>
References: <20101026112052.GA1672@arch.trippelsdorf.de>  <20101026131843.GC17852@aftab> <20101026135808.GB1672@arch.trippelsdorf.de> <1288103930.15336.321.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Peter Zijlstra wrote:

> On Tue, 2010-10-26 at 15:58 +0200, Markus Trippelsdorf wrote:
> > > 
> > > This is strange, tsc is actually stable on your F10h revC.
> > 
> > Yes. constant_tsc is among the CPU flags. 
>  
> constant_tsc only means the TSC is not affected by cpu freq changes.
> 
> It has zero relevance to cross-cpu sync of the TSC. The clocksource
> stuff requires your TSC to be synchronous over all your CPUs.

That and not affected by C-States either.

Thanks,

	tglx
