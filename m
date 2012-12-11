Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab2LKRWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:22:33 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52296 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782Ab2LKRWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:22:31 -0500
X-Sasl-enc: CW56OYF+lPnLFEbc1XjXpKz6VrJM4uPHDXzht1CY0mSE 1355246550
Date: Tue, 11 Dec 2012 09:24:58 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: linux-next: manual merge of the gpio-lw tree with the
 driver-core tree
Message-ID: <20121211172458.GA3309@kroah.com>
References: <20121211151310.04fcd54a9412f5d60f08367f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211151310.04fcd54a9412f5d60f08367f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 03:13:10PM +1100, Stephen Rothwell wrote:
> Hi Linus,
> 
> Today's linux-next merge of the gpio-lw tree got a conflict in
> drivers/gpio/gpio-stmpe.c between commit 3836309d9346 ("gpio: remove use
> of __devinit") from the driver-core tree and commit fc13d5a5b17c ("gpio:
> Provide the STMPE GPIO driver with its own IRQ Domain") from the gpio-lw
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
