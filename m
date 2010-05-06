Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab0EFUI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:08:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab0EFUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:08:57 -0400
Date: Thu, 6 May 2010 16:08:54 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Kyle McMartin <kyle@mcmartin.ca>, wzt.wzt@gmail.com,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       deller@gmx.de, jejb@parisc-linux.org
Subject: Re: [PATCH] Parisc: Check kmalloc return value before use the
	buffer in ccio-dma.c
Message-ID: <20100506200854.GG4902@bombadil.infradead.org>
References: <20100506024208.GB15956@localhost.localdomain> <20100506040331.GC4902@bombadil.infradead.org> <20100506105948.GV6747@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506105948.GV6747@parisc-linux.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 04:59:48AM -0600, Matthew Wilcox wrote:
> On Thu, May 06, 2010 at 12:03:31AM -0400, Kyle McMartin wrote:
> > We can change it to GFP_ATOMIC|__GFP_NOFAIL so it will retry infinitely,
> > or we can panic in the error path with a nice error message so the users
> > knows why his machine isn't going to work.
> 
> If we can't initialise the IOMMU, can we even get a panic message out to
> the user?
> 

Excellent question! I'm not sure. IODC console will still be working up
until it gets bonked, so early_console is probably still functional up
until that point.

--Kyle
