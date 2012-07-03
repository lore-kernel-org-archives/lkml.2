Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab2GCXDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 19:03:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35097 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998Ab2GCXDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:03:06 -0400
X-Sasl-enc: ATP+ThZJFVbFPSa4+zk5MKLkfSEU4lCghyPs4MEPWdLg 1341356585
Date: Tue, 3 Jul 2012 16:03:04 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russ Dill <Russ.Dill@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the usb tree with the mfd tree
Message-ID: <20120703230304.GA15624@kroah.com>
References: <20120703140938.b2ae0cf0ce2a3a470bb6cec6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703140938.b2ae0cf0ce2a3a470bb6cec6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 02:09:38PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/ehci-omap.c between commit 996439f8fa07 ("mfd: USB: Fix
> the omap-usb EHCI ULPI PHY reset fix issues") from the mfd tree and
> commit 984e97483a14 ("ARM: OMAP: USB: Fixup ehci_hcd_omap_probe error
> path") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good to me, thanks.

greg k-h
