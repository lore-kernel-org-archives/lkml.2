Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab2LCSZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:25:49 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54110 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab2LCSZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:25:47 -0500
X-Sasl-enc: uwIoXvVUdQHn8Ywsc5GKRGp+TQkumlp99QKn2X2jhJTB 1354559146
Date: Mon, 3 Dec 2012 10:25:45 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the slave_dma
 and tree
Message-ID: <20121203182545.GA32702@kroah.com>
References: <20121203171232.04772e84d18948bbbcafdeef@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203171232.04772e84d18948bbbcafdeef@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 05:12:32PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/dma/mv_xor.c between commit d51e88b99533 ("dma: Convert dev_printk
> (KERN_<LEVEL> to dev_<level>(") from the slave-dma tree, commits
> a7d6e3ec28bb ("dma: remove use of __devexit_p") and 463a1f8b3cee ("dma:
> remove use of __devinit") from the driver-core tree and various commits
> from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
