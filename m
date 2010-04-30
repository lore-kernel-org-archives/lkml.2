Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab0D3RfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:35:19 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:47584 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab0D3Rew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:34:52 -0400
Subject: Re: mmotm 2010-04-28-16-53 uploaded
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
In-Reply-To: <20100429150031.5d0e76ad.akpm@linux-foundation.org>
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
	 <18962.1272576730@localhost>
	 <20100429145333.f81c634b.akpm@linux-foundation.org>
	 <20100429150031.5d0e76ad.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: HP/LKTT
Date: Fri, 30 Apr 2010 08:11:37 -0400
Message-Id: <1272629497.10027.3.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 15:00 -0700, Andrew Morton wrote:
> On Thu, 29 Apr 2010 14:53:33 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 29 Apr 2010 17:32:10 -0400
> > Valdis.Kletnieks@vt.edu wrote:
> > 
> > > On Wed, 28 Apr 2010 16:53:32 PDT, akpm@linux-foundation.org said:
> > > > The mm-of-the-moment snapshot 2010-04-28-16-53 has been uploaded to
> > > > 
> > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > Dies trying to compile mm/slab.c because something screwed the pooch with
> > > the definition of numa_mem_id(). My bets are on
> > > numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
> > 
> > It Works For Me.  Send .config, please?
> 
> Is OK, I found one.  i386 .config below.
> 
> Yes, it's numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch. 
> I stared at it for a bit and got bored - it's Lee's turn ;)

Working on it.

Thought I'd preserved other archs, but i386 shares some headers and
other files with x86_64 and I apparently botched one of those.

I have a number of other reworks as well that I hope to send out later
today.

Lee

