Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1E3Jjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:39:51 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35728 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297Ab1E3Jju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:39:50 -0400
X-Sasl-enc: U53D0d5E/ktFLUr9tybSedSRPEOG9QD+CToI6ydiUh1a 1306748389
Date: Mon, 30 May 2011 17:40:46 +0800
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: kevin.tian@intel.com, dkiper@net-space.pl, Rzeszutek@dumpdata.com,
        Wilk@dumpdata.com, stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] Xen bug-fixes for 2.6.39 (already in 2.6.40)
Message-ID: <20110530094046.GF11601@kroah.com>
References: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
 <20110526070239.GB29833@kroah.com>
 <20110526123921.GB3386@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526123921.GB3386@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:39:21AM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, May 26, 2011 at 12:02:39AM -0700, Greg KH wrote:
> > On Wed, May 25, 2011 at 05:37:32PM -0400, Konrad@dumpdata.com wrote:
> > > Hey stable-tree maintainer(s).
> > > 
> > > The follow four patches are in the 2.6.40 tree and should be back-ported to 2.6.39 (only).
> > > I forgot to CC:stable on them, so manually doing it here.
> > > 
> > > The four patches in question have the following git commits:
> > > 
> > > 8c5950881c3b5e6e350e4b0438a8ccc513d90df9
> > >     xen/p2m: Create entries in the P2M_MFN trees's to track 1-1 mappings
> > > 0f16d0dfcdb5aab97d9e368f008b070b5b3ec6d3
> > >     xen/setup: Fix for incorrect xen_extra_mem_start initialization under 32-bit
> > > 15bfc094517db2ddf38ca7ed47f3a1c0ad24f7c4
> > >     xen/setup: Ignore E820_UNUSABLE when setting 1-1 mappings.
> > > 7899891c7d161752f29abcc9bc0a9c6c3a3af26c
> > >     xen mmu: fix a race window causing leave_mm BUG()
> > > 
> > > And are part of this email chain. Please apply them to 2.6.39.1 tree.
> > 
> > I need an ack from the Xen maintainer and the original patch author
> > before I can accept these.  Please get them to provide this and I will
> 
> OK
> 
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> (who is the Xen maintainer)
> 
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> (who is also the original patch author on some of the patches)

Thanks, as you didn't send the original request from your maintainer
address, how was I to know that you were the same Konrad Rzeszutek Wilk?  :)

thanks,

greg k-h
