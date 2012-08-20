Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2HTI0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:26:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:48099 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab2HTI0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:26:45 -0400
Message-ID: <1345451187.23018.15.camel@twins>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Date: Mon, 20 Aug 2012 10:26:27 +0200
In-Reply-To: <20120820080606.GA6931@gmail.com>
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>
	 <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins>
	 <502BB5A3.5000403@linux.intel.com> <1345043096.31459.106.camel@twins>
	 <502BE38D.9030405@linux.intel.com> <20120820080606.GA6931@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 10:06 +0200, Ingo Molnar wrote:
> > > I was really more thinking of something useful for the 
> > > laptops out there, when they pull the power cord it makes 
> > > sense to try and keep CPUs asleep until the one that's awake 
> > > is saturated.
> 
> s/CPU/core ? 

I was thinking logical cpus, but whatever really.
