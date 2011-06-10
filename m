Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab1FJS7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:59:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44331 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1FJS7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:59:40 -0400
Date: Fri, 10 Jun 2011 19:58:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, tglx@linutronix.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, pavel@ucw.cz
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
	instead of failing
Message-ID: <20110610185858.GN24424@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com> <20110601181918.GO3660@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1106012043080.3078@ionos> <alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com> <alpine.LFD.2.02.1106012134120.3078@ionos> <4DF1C9DE.4070605@jp.fujitsu.com> <20110610004331.13672278.akpm@linux-foundation.org> <BANLkTimC8K2_H7ZEu2XYoWdA09-3XxpV7Q@mail.gmail.com> <20110610091233.GJ24424@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1106101150280.17197@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106101150280.17197@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 11:54:16AM -0700, David Rientjes wrote:
> On Fri, 10 Jun 2011, Russell King - ARM Linux wrote:
> 
> > > Should one submit a patch adding a warning to GFP_DMA allocations
> > > w/o ZONE_DMA, or the idea of the original patch is wrong?
> > 
> > Linus was far from impressed by the original commit, saying:
> > | Using GFP_DMA is reasonable in a driver - on platforms where that
> > | matters, it should allocate from the DMA zone, on platforms where it
> > | doesn't matter it should be a no-op.
> > 
> > So no, not even a warning.
> > 
> 
> Any words of wisdom for users with CONFIG_ZONE_DMA=n that actually use 
> drivers where they need GFP_DMA?  The page allocator should just silently 
> return memory from anywhere?

See Linus' reply.  I quote again "on platforms where it doesn't matter it
should be a no-op".  If _you_ have a problem with that _you_ need to
discuss it with _Linus_, not me.  I'm not going to be a middle-man sitting
between two people with different opinions.
