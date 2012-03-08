Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab2CHR7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:59:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44395 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab2CHR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:59:47 -0500
Date: Thu, 8 Mar 2012 09:59:41 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        netdev@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org,
        linux-serial@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] powerpc: remove the legacy iSeries platform specific
 drivers
Message-ID: <20120308175941.GB26516@kroah.com>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 03:28:53PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> This series of patches removes all the legacy iSeries platform specific
> drivers (and the iSeries specific part of one).  The legacy iSeries
> platform main code has already bee removed along with CONFIG_PPC_ISERIES,
> so none of this code is selectable or needed any more.
> 
> It would probably be easiest if all these patches were merged via the
> powerpc tree to eliminate any dependencies between them.  Their impact on
> generic code is very small.

No objection from me at all.

greg k-h
