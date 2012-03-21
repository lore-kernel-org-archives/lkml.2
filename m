Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab2CUP5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:57:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:52893 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab2CUP5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:57:17 -0400
Message-ID: <1332345420.18960.495.camel@twins>
Subject: Re: Regression in v3.4-rc0 " BUG: soft lockup - CPU#0 stuck for
 29s! [migration/0:6]..[<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        gregkh@linuxfoundation.org, rjw@sisk.pl
Date: Wed, 21 Mar 2012 16:57:00 +0100
In-Reply-To: <20120321152649.GA32737@phenom.dumpdata.com>
References: <20120320235322.GA5416@phenom.dumpdata.com>
	 <20120321152649.GA32737@phenom.dumpdata.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 11:26 -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 20, 2012 at 07:53:22PM -0400, Konrad Rzeszutek Wilk wrote:
> > Seeing this in v3.4-rc0 tree and didn't see that with v3.3:
> 
> Hey Peter,
> 
> Git bisection points this to the fault of
> 5fbd036b552f633abb394a319f7c62a5c86a9cd7 " sched: Cleanup cpu_active madness"
> 
> thoughts? (also attaching the .config) 

Argh.. so when is this? boot? No that's somewhat unexpected. I have one
report of funnies during a hotplug bash that I'm looking into, but I
haven't actually been able to reproduce that report myself either.


