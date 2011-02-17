Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab1BQSGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:06:22 -0500
Received: from kroah.org ([198.145.64.141]:53449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442Ab1BQSGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:06:19 -0500
Date: Thu, 17 Feb 2011 10:04:56 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus' tree
Message-ID: <20110217180456.GA17077@kroah.com>
References: <20110207150802.4869bd47.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207150802.4869bd47.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 03:08:02PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/ehci-pci.c between commit
> baab93afc2844b68d57b0dcca5e1d34c5d7cf411 ("USB: EHCI: ASPM quirk of ISOC
> on AMD Hudson") from Linus' tree and commit
> b7d5b439b7a40dd0a0202fe1c118615a3fcc3b25 ("USB host: Move AMD PLL quirk
> to pci-quirks.c") from the usb tree.
> 
> I just use the version from the usb tree, but this may need fixing up in
> pci-quirks.c.

I have reverted the patch in the usb-next tree, and merged with Linus's
tree, so the usb-next tree should be all good now.

Andriy, can you resend me a new version of this patch that I can apply,
as I couldn't resolve the merge issues, they were just too great.

thanks,

greg k-h
