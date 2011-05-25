Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab1EYM6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:58:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38089 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab1EYM6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:58:45 -0400
Date: Wed, 25 May 2011 08:58:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110525125829.GC3467@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <20110524155007.GB29481@dumpdata.com>
 <1748634cd0eef25a5edea99e1953fe65@admin.gogi.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1748634cd0eef25a5edea99e1953fe65@admin.gogi.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4DDCFCFF.0028:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:33:08PM +0100, Daniel Haid wrote:
> >Not bug per say. I've been working on making the TTM use the DMA API
> >so that those pages are allocated at startup and you don't end up
> >with having to sync the pages .. but I broke PowerPC and ARM
> >during 2.6.39
> >so I need to redo it.
> 
> If this is not a bug, shouldn't there be a message like
> "radeon currently does not work with SWIOTLB, disabling..."
> instead of
> "ring test failed, disabling..."?

Or perhaps just fix the driver? That is what I am working on - are you
interested in doing some beta-testing when they are ready?
