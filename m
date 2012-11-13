Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2KMTUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:20:11 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46612 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261Ab2KMTUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:20:09 -0500
X-Sasl-enc: u0Iti/cnXMVbfLNWOowoGzEdHe1yXajA59fzN6mQEDlR 1352834408
Date: Tue, 13 Nov 2012 11:20:07 -0800
From: Greg Kroah-Hartman <greg@kroah.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: Use dev_ printks in drivers/adl_pci9118.c
Message-ID: <20121113192007.GA8677@kroah.com>
References: <1351949883-16164-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351949883-16164-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 10:38:03PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warnings.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/comedi/drivers/adl_pci9118.c |   31 ++++++++++++++------------
>  1 file changed, 17 insertions(+), 14 deletions(-)

This does not apply at all, sorry.

greg k-h
