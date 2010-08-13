Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006Ab0HMRzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 13:55:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761964Ab0HMRzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 13:55:03 -0400
Date: Fri, 13 Aug 2010 10:54:56 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: EXPORT_SYMBOL(fat_get_block)
Message-ID: <20100813175456.GB15024@suse.de>
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

Also, why do this at the FAT level, and not more correctly at the block
layer level?  What happens if this isn't a FAT partition on the device?

thanks,

greg k-h
