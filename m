Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956Ab0HMRyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 13:54:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab0HMRyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 13:54:11 -0400
Date: Fri, 13 Aug 2010 10:54:02 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: EXPORT_SYMBOL(fat_get_block)
Message-ID: <20100813175402.GA15024@suse.de>
References: <1281721539.5839.4.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281721539.5839.4.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 10:45:39AM -0700, David Cross wrote:
> Hello Hirofumi,
> I would like to export this symbol from the vfat code and add this patch
> to the Linux kernel. You are listed as the MAINTAINER for FAT and VFAT.
> As such, I need your approval to do it. 
> The reason that I need to export this symbol is to allow for file based
> DMA in which the file needs to be pre-allocated. The pre-allocated block
> addresses are passed to a DMA engine which then directly transfers the
> data to non-volatile storage.
> Please let me know if you have any objections to exporting this symbol
> or if you need additional information from me concerning this change
> request. I am happy to answer any questions that you may have about this
> in the meantime.

Wait, _I_ have an objection to exporting this symbol.

I really don't think it is needed at this point in time, as we really
need to figure out exactly what your driver is doing to want to need to
call this function.

So please, let's not export it for now, when we get to the point that we
all agree that this driver is doing the "correct" thing, then we can
export the symbol, ok?

thanks,

greg k-h
