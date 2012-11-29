Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab2K2FPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:15:43 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50489 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907Ab2K2FPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:15:42 -0500
X-Sasl-enc: a+NBvVOyICj94SCGecg1XbHltOKuneEiLrScOL6jLlUv 1354166141
Date: Wed, 28 Nov 2012 21:17:19 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: manual merge of the gpio tree with the driver-core
 tree
Message-ID: <20121129051719.GC4375@kroah.com>
References: <20121129155723.60035c6419fd9a00f46e4d69@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129155723.60035c6419fd9a00f46e4d69@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:57:23PM +1100, Stephen Rothwell wrote:
> Hi Grant,
> 
> Today's linux-next merge of the gpio tree got a conflict in
> drivers/gpio/gpio-em.c between commit 3836309d9346 ("gpio: remove use of
> __devinit") from the driver-core tree and commit 7385500a49b7 ("gpio/em:
> convert to linear IRQ domain") from the gpio tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
