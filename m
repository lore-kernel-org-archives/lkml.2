Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab2HVJKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:10:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53578 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2HVJKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:10:20 -0400
Date: Wed, 22 Aug 2012 11:10:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120822091013.GB23336@gmail.com>
References: <20120820080606.GA6931@gmail.com>
 <20120820181651.GA737@srcf.ucam.org>
 <20120821094203.GB12385@gmail.com>
 <20120821113951.GA22436@srcf.ucam.org>
 <20120821151910.GA5359@gmail.com>
 <20120821152828.GB28241@srcf.ucam.org>
 <20120821155908.GA5499@gmail.com>
 <20120821161324.GA29665@srcf.ucam.org>
 <20120821182346.GA7325@gmail.com>
 <20120821183414.GA436@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821183414.GA436@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> [...]
>
> Our power consumption is worse than under other operating 
> systems is almost entirely because only one of our three GPU 
> drivers implements any kind of useful power management. [...]

... and because our CPU frequency and C state selection logic is 
doing pretty much the worst possible decisions (on x86 at 
least).

Regardless, you cannot possibly seriously suggest that because 
there's even greater suckage elsewhere for some workloads we 
should not even bother with improving the situation here.

Anyway, I agree with Alan that actual numbers matter.

Thanks,

	Ingo
