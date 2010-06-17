Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab0FQMsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:48:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:40809 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab0FQMsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:48:21 -0400
Date: Thu, 17 Jun 2010 21:48:05 +0900
To: jaxboe@fusionio.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] remove useless ISA_DMA_THRESHOLD
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100602061815.GH3564@kernel.dk>
References: <20100601182452.GA3564@kernel.dk>
	<20100602113022I.fujita.tomonori@lab.ntt.co.jp>
	<20100602061815.GH3564@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100617214643N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 17 Jun 2010 21:48:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 08:18:15 +0200
Jens Axboe <jaxboe@fusionio.com> wrote:

> On Tue, Jun 01 2010, FUJITA Tomonori wrote:
> > On Tue, 1 Jun 2010 20:24:52 +0200
> > Jens Axboe <jaxboe@fusionio.com> wrote:
> > 
> > > On Mon, May 31 2010, FUJITA Tomonori wrote:
> > > > This patchset removes useless ISA_DMA_THRESHOLD:
> > > > 
> > > > - ISA_DMA_THRESHOLD is irrelevant to the majority of architectures but
> > > >   they have to define it.
> > > > 
> > > > - ISA_DMA_THRESHOLD definition is inconsistent on architectures; ISA
> > > >   DMA addressing restriction, DMA addressing restriction or something
> > > >   else.
> > > > 
> > > > - Everyone (except for SCSI) uses dma_mask instead of ancient
> > > >   ISA_DMA_THRESHOLD.
> > > > 
> > > > Only SCSI uses ISA_DMA_THRESHOLD for ancient drivers with non-zero
> > > > unchecked_isa_dma. We can safely remove ISA_DMA_THRESHOLD usage in
> > > > SCSI. So we can clean up ISA_DMA_THRESHOLD on the whole tree.
> > > 
> > > Looks good. James, it's probably easier if I just carry this patch set.
> > 
> > Thanks,
> > 
> > Any tree works for me, I thought about -mm though.
> > 
> > Can you replace [1/3] with the following?
> > 
> > I fixed the subject and the body, s/aha1532/aha1542/;
> > 
> > Somehow I forgot to remove unused BAD_SG_DMA().
> 
> I'll collect the acks and include this update.

Can you send this to -next via your tree? I want this to be
compile-tested on -next on various architectures.

Thanks,
