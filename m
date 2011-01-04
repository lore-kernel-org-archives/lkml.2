Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab1ADXpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:45:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1ADXpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:45:18 -0500
Date: Tue, 4 Jan 2011 15:44:40 -0800
From: Greg KH <gregkh@suse.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 0/2] Annotate gpio-configuration with __must_check
Message-ID: <20110104234440.GC30328@suse.de>
References: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
 <20110104202718.GA31444@suse.de>
 <20110104212916.GA14436@pengutronix.de>
 <20110104213414.GA6774@suse.de>
 <20110104230508.GA18363@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104230508.GA18363@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 12:05:08AM +0100, Wolfram Sang wrote:
> 
> > > should fail if it cannot be requested. Or not. Things get worse for
> > > architectures I never used before. This is why I think it is really better to
> > > let people do the fixups who have/understand the hardware in question.
> > > Otherwise the fixups could indeed be more harmful than helpful.
> > 
> > Sure, they could be more harmful, but at least try.  Make the patches
> > up, submit them to the maintainers, and if they are wrong, they will be
> > the best to fix it up properly.
> 
> Well, I could generalize all cases and always issue a WARN() if the request
> fails. But this would just move a compile-time warning into a runtime warning.
> Also, I have my doubts that even the arch/mach-maintainers know all the boards
> and their peculiarities. There are thousands of them.

Well, they better know the peculiarities of the hardware they write code
for :)

But no, a WARN() might not be that nice as it usually is never seen by
embedded developers...

thanks,

greg k-h
