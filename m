Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2K2FTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:19:15 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41752 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab2K2FTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:19:12 -0500
X-Sasl-enc: fcl8DF7ye7kGGvVjhG798JBOyAChHX1z5R6WCBfc+jGY 1354166351
Date: Wed, 28 Nov 2012 21:20:49 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the mfd
 tree
Message-ID: <20121129052049.GQ4375@kroah.com>
References: <20121129145039.dc5c58ab8990d7ffe35d3291@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129145039.dc5c58ab8990d7ffe35d3291@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:50:39PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/mfd/da9052-core.c between commit 8bad1abd6303 ("mfd: da9052:
> Introduce da9052-irq.c") from the mfd tree and commit a9e9ce4c4167 ("mfd:
> remove use of __devinitdata") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
