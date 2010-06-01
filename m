Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0FASew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:34:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:36855 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0FASeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:34:50 -0400
Subject: Re: [PATCH -mm 0/3] remove useless ISA_DMA_THRESHOLD
From: James Bottomley <James.Bottomley@suse.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20100601182452.GA3564@kernel.dk>
References: <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <20100601182452.GA3564@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 13:34:43 -0500
Message-ID: <1275417283.21962.646.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 20:24 +0200, Jens Axboe wrote:
> On Mon, May 31 2010, FUJITA Tomonori wrote:
> > This patchset removes useless ISA_DMA_THRESHOLD:
> > 
> > - ISA_DMA_THRESHOLD is irrelevant to the majority of architectures but
> >   they have to define it.
> > 
> > - ISA_DMA_THRESHOLD definition is inconsistent on architectures; ISA
> >   DMA addressing restriction, DMA addressing restriction or something
> >   else.
> > 
> > - Everyone (except for SCSI) uses dma_mask instead of ancient
> >   ISA_DMA_THRESHOLD.
> > 
> > Only SCSI uses ISA_DMA_THRESHOLD for ancient drivers with non-zero
> > unchecked_isa_dma. We can safely remove ISA_DMA_THRESHOLD usage in
> > SCSI. So we can clean up ISA_DMA_THRESHOLD on the whole tree.
> 
> Looks good. James, it's probably easier if I just carry this patch set.

Sure, acked by me.

James



