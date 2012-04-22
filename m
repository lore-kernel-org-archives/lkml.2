Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab2DVWgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 18:36:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34965 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623Ab2DVWgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 18:36:21 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2012 18:36:21 EDT
X-Sasl-enc: H7r44qgwJCUx/9lpq91p8jHKwOObrkWYLWsNR5HUHy2K 1335133678
Date: Sun, 22 Apr 2012 15:27:57 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>,
        Ramneek Mehresh <ramneek.mehresh@freescale.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20120422222757.GA26593@kroah.com>
References: <20120419151402.6f958fabc6bd96696b4cde3c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419151402.6f958fabc6bd96696b4cde3c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 03:14:02PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/ehci-fsl.c between commit f941f6922533 ("USB: ehci-fsl:
> Fix kernel crash on mpc5121e") from the usb.current tree and commit
> 58c559e6509f ("fsl/usb: Add controller version based ULPI and UTMI phy
> support") from the usb tree.
> 
> I fixed it up (using the pdata assignment from the latter commit) and
> can carry the fix as necessary.

This should now be resolved in my tree.

thanks,

greg k-h
