Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2K2FSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:18:47 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42266 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab2K2FSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:18:45 -0500
X-Sasl-enc: 1tbkj0mIxfIxl7uesdJf1ya8u501Ihpq47aP9SbKaWm4 1354166324
Date: Wed, 28 Nov 2012 21:20:21 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the pci
 tree
Message-ID: <20121129052021.GN4375@kroah.com>
References: <20121129150340.768fdffc941d501c9975c2be@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129150340.768fdffc941d501c9975c2be@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:03:40PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/pci/pci.h between commit 4e15c46bdc4d ("PCI: Add pci_device_type
> to pdev's device struct") from the pci tree and commit b40b97ae736c
> ("PCI: Remove CONFIG_HOTPLUG ifdefs") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
