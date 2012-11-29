Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2K2FRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:17:51 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38576 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907Ab2K2FRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:17:49 -0500
X-Sasl-enc: 0r+QrJTTMTFz4BabRnw0XwdyV6O7GsTCW4AQwGb81jBk 1354166268
Date: Wed, 28 Nov 2012 21:19:26 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the mfd
 tree
Message-ID: <20121129051926.GH4375@kroah.com>
References: <20121129151804.a133338f9738b25d3ccf2e6f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129151804.a133338f9738b25d3ccf2e6f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:18:04PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/power/da9052-battery.c between commit 4b5edf7887c6 ("power:
> da9052-battery: Convert to the new da9052 interrupt functions") from the
> mfd tree and commit c8afa6406e60 ("power: remove use of __devinit") from
> the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
