Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2HVLf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:35:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45654 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2HVLfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:35:24 -0400
Date: Wed, 22 Aug 2012 12:35:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120822113508.GA19152@srcf.ucam.org>
References: <20120820181651.GA737@srcf.ucam.org>
 <20120821094203.GB12385@gmail.com>
 <20120821113951.GA22436@srcf.ucam.org>
 <20120821151910.GA5359@gmail.com>
 <20120821152828.GB28241@srcf.ucam.org>
 <20120821155908.GA5499@gmail.com>
 <20120821161324.GA29665@srcf.ucam.org>
 <20120821182346.GA7325@gmail.com>
 <20120821183414.GA436@srcf.ucam.org>
 <20120822091013.GB23336@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822091013.GB23336@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 11:10:13AM +0200, Ingo Molnar wrote:
> 
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > [...]
> >
> > Our power consumption is worse than under other operating 
> > systems is almost entirely because only one of our three GPU 
> > drivers implements any kind of useful power management. [...]
> 
> ... and because our CPU frequency and C state selection logic is 
> doing pretty much the worst possible decisions (on x86 at 
> least).

You have figures showing that our C state residence is worse than, say, 
Windows? Because my own testing says that we're way better at that. 
Could we be better? Sure. Is it why we're worse? No.

> Regardless, you cannot possibly seriously suggest that because 
> there's even greater suckage elsewhere for some workloads we 
> should not even bother with improving the situation here.

I'm enthusiastic about improving the scheduler's behaviour. I'm 
unenthusiastic about putting in automatic hacks related to AC state.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
