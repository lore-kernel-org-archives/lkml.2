Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab2K2FSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:18:39 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54073 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727Ab2K2FSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:18:36 -0500
X-Sasl-enc: I13FxmvhgjS2sOApnX9tZunYtoJNuxDUkdEmI+PT+MiF 1354166315
Date: Wed, 28 Nov 2012 21:20:13 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Ian Abbott <abbotti@mev.co.uk>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the pci
 tree
Message-ID: <20121129052013.GM4375@kroah.com>
References: <20121129150641.a049c1048c4085d339e5f591@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129150641.a049c1048c4085d339e5f591@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:06:41PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/pci/quirks.c between commit 21c5fd97380b ("PCI: Add workaround
> for PLX PCI 9050 BAR alignment erratum") from the pci tree and commit
> 15856ad50bf5 ("PCI: Remove __dev* markings") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
