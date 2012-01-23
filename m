Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2AWVBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:01:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:33197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2AWVBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:01:02 -0500
Message-ID: <1327352449.2446.19.camel@twins>
Subject: Re: v3.3-rc1, regression introduced by "sched, nohz: Implement
 sched group, domain aware nohz idle load balancing" when unplugging CPUs.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, gregkh@suse.de, rjw@sisk.pl
Date: Mon, 23 Jan 2012 22:00:49 +0100
In-Reply-To: <20120123205638.GA8542@phenom.dumpdata.com>
References: <20120123205638.GA8542@phenom.dumpdata.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 15:56 -0500, Konrad Rzeszutek Wilk wrote:
> Not exactly sure how this patch does it, but with this git commit
> 0b005cf54eac170a8f22540ab096a6e07bf49e7c, the Linux kernel crashes
> if I try to hot unplug VCPUs to the first (initial) domain.
> This is found using git bisection, and if I use the kernel compiled
> with 69e1e811dcc436a6b129dbef273ad9ec22d095ce (the previous commit)
> it works nicely. 

https://lkml.org/lkml/2012/1/19/463

is already on its way...
