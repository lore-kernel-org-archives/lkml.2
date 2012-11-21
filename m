Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2KUUVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:21:20 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61999 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2KUUVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:21:18 -0500
Date: Wed, 21 Nov 2012 12:21:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas =?iso-8859-1?Q?Bie=DFmann?= <andreas.devel@googlemail.com>
Cc: Felipe Balbi <balbi@ti.com>, linux@arm.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "serial: omap: fix software flow control"
Message-ID: <20121121202114.GC30682@kroah.com>
References: <1350396562-32579-1-git-send-email-balbi@ti.com>
 <509A306B.10409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <509A306B.10409@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 10:56:59AM +0100, Andreas Bießmann wrote:
> On 16.10.2012 16:09, Felipe Balbi wrote:
> > This reverts commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6
> > (serial: omap: fix software flow control).
> > 
> > As Russell has pointed out, that commit isn't fixing
> > Software Flow Control at all, and it actually makes
> > it even more broken.
> > 
> > It was agreed to revert this commit and use Russell's
> > latest UART patches instead.
> > 
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> 
> since 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6 made it into stable (at
> least 3.4) I think it would be good decision to also apply this revert
> to stable until a working solution exists.

Now queued up for the stable releases, thanks.

greg k-h
