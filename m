Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2HOOjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:39:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:38415 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2HOOjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:39:23 -0400
Message-ID: <1345041548.31459.90.camel@twins>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        vincent.guittot@linaro.org, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Date: Wed, 15 Aug 2012 16:39:08 +0200
In-Reply-To: <502BA7DC.7060907@linux.intel.com>
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>
	 <502BA7DC.7060907@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 06:45 -0700, Arjan van de Ven wrote:
> On 8/15/2012 4:05 AM, Peter Zijlstra wrote:
> > Yay, ideally we'd also provide a 3rd option: auto, which simply switches
> > between the two based on AC/BAT, UPS 
> 
> nooooooo!
> 
> anything but this.
> if anyone thinks that AC/Battery matters for power sensitivity... they
> need to go talk to a datacenter operator ;-)

Servers in a datacenter have battery?

> seriously, there are possibly many ways to have a power/performance
> preference..,. but AC/battery is a very very poor one.
> 
Do expand..
