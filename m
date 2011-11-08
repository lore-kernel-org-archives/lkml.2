Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab1KHXxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:53:09 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59704 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756520Ab1KHXxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:53:07 -0500
X-Sasl-enc: cfG6EOXCFjSOC6GmFvsKdRzYWzQN6ynekFovFYvqnrXq 1320796386
Date: Tue, 8 Nov 2011 15:46:49 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Jiajun Wu <b06378@freescale.com>, Li Yang <leoli@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: ppc: irq_choose_cpu breaks build [was: Linux 2.6.32.47]
Message-ID: <20111108234649.GA4380@kroah.com>
References: <20111107213431.GA8483@kroah.com>
 <4EB9A373.1010508@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB9A373.1010508@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 10:47:31PM +0100, Jiri Slaby wrote:
> Damn, CCs fixed.
> 
> On 11/07/2011 10:34 PM, Greg KH wrote:
> >I'm announcing the release of the 2.6.32.47 kernel.
> ...
> >Yang Li (1):
> >       powerpc/mpic: Fix problem that affinity is not updated
> 
> Hi, this one is broken:
> arch/powerpc/sysdev/mpic.c: In function 'irq_choose_cpu':
> arch/powerpc/sysdev/mpic.c:574: error: passing argument 1 of
> '__cpus_equal' from incompatible pointer type
> 
> Why the backport of the patch misses the cpus_equal -> cpumask_equal switch?

Ugh, not good, I'll go revert this, thanks for letting me know.

greg k-h
