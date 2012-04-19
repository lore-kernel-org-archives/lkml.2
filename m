Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2DSUHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:07:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35550 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246Ab2DSUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:07:23 -0400
X-Sasl-enc: w82GOCMorZaozT4HSs10i4BkuI3QYiG+mO/TaGTYWatw 1334866042
Date: Thu, 19 Apr 2012 13:07:21 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>,
        Ramneek Mehresh <ramneek.mehresh@freescale.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20120419200721.GB10059@kroah.com>
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

Thanks, that sounds correct, I'll fix this up when the patches in
usb.current get pushed to Linus.

greg k-h
