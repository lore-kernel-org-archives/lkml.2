Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343Ab2JXS5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:57:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36921 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934943Ab2JXS5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:57:46 -0400
Date: Wed, 24 Oct 2012 11:57:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux@arm.linux.org.uk, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] Revert "serial: omap: fix software flow control"
Message-ID: <20121024185742.GA26995@kroah.com>
References: <1350396562-32579-1-git-send-email-balbi@ti.com>
 <20121016151357.GN15569@atomide.com>
 <20121024100254.GG5665@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024100254.GG5665@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 01:02:55PM +0300, Felipe Balbi wrote:
> Hi Greg,
> 
> On Tue, Oct 16, 2012 at 08:13:59AM -0700, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [121016 07:16]:
> > > This reverts commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6
> > > (serial: omap: fix software flow control).
> > > 
> > > As Russell has pointed out, that commit isn't fixing
> > > Software Flow Control at all, and it actually makes
> > > it even more broken.
> > > 
> > > It was agreed to revert this commit and use Russell's
> > > latest UART patches instead.
> > > 
> > > Cc: Russell King <linux@arm.linux.org.uk>
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > 
> > This seems like the best way to go for the -rc series:
> > 
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> Any chance you can pick this one up for v3.7-rc3 ?

Now queued up, sorry for the delay.

greg k-h
