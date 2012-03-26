Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2CZGP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:15:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:44931 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab2CZGPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:15:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="121609578"
Subject: Re: linux-next: manual merge of the l2-mtd tree with the slave-dma
 tree
From: Vinod Koul <vinod.koul@linux.intel.com>
To: dedekind1@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Huang Shijie <b32955@freescale.com>
In-Reply-To: <1332408753.18717.1.camel@sauron.fi.intel.com>
References: <20120322140410.2f9af2f25906a3cdc9497d72@canb.auug.org.au>
	 <1332408753.18717.1.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 11:48:47 +0530
Message-ID: <1332742727.19804.20.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 11:32 +0200, Artem Bityutskiy wrote:
> On Thu, 2012-03-22 at 14:04 +1100, Stephen Rothwell wrote:
> > Hi Artem,
> > 
> > Today's linux-next merge of the l2-mtd tree got a conflict in
> > drivers/mtd/nand/gpmi-nand/gpmi-lib.c between commit 16052827d98f
> > ("dmaengine/dma_slave: introduce inline wrappers") from the slave-dma
> > tree and commit c790d78c631f ("mxs-dma : rewrite the last parameter of
> > mxs_dma_prep_slave_sg()") from the l2-mtd tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> Looks like Vinod merged a lot of changes recently. Thanks for fixing
> this up in linux-next!
Thanks Again, loks right to me too.

Yes i had a pending series which I applied just before I went for
weekend.


-- 
~Vinod

