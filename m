Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab1ANBHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:07:07 -0500
Received: from kroah.org ([198.145.64.141]:59639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab1ANBHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:07:01 -0500
Date: Thu, 13 Jan 2011 17:06:07 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warnings in Linus' tree
Message-ID: <20110114010607.GA27486@kroah.com>
References: <20110114110952.bb7d6f37.sfr@canb.auug.org.au>
 <20110113161700.a82a0ae2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113161700.a82a0ae2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 04:17:00PM -0800, Andrew Morton wrote:
> On Fri, 14 Jan 2011 11:09:52 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > drivers/net/wireless/p54/p54spi.c:642: warning: ignoring return value of 'gpio_direction_input', declared with attribute warn_unused_result
> > 
> > Introduced by commit 0fdae42d361bbb431ca0ab0efed5126a94821177 ("gpiolib:
> > annotate gpio-intialization with __must_check").
> 
> Complete brainfart - I meant to drop that patch ages ago.

Ick, yeah, that patch isn't ok to go in as-is, all of the callers need
to be fixed up first, which is what I thought we had agreed on...

thanks,

greg k-h
