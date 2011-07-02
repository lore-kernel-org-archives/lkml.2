Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1GBKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 06:09:59 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:53674 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab1GBKJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 06:09:57 -0400
Date: Sat, 2 Jul 2011 14:09:03 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into
	ehci-sysfs.c
Message-ID: <20110702100903.GB18338@tugrik.mns.mnsspb.ru>
References: <20110701114927.GA15802@tugrik.mns.mnsspb.ru> <Pine.LNX.4.44L0.1107011139560.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107011139560.1988-100000@iolanthe.rowland.org>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 11:41:05AM -0400, Alan Stern wrote:
> On Fri, 1 Jul 2011, Kirill Smelkov wrote:
> 
> > > > The checking is not a priority for me here, so if you think it's better not
> > > > to check or do it under #ifdef - let's do it. Though of course we all
> > > > have our preferences :)
> > > 
> > > Yes, it's just a matter of taste.  I prefer to add as little code as 
> > > possible for a feature that won't be used much.
> > 
> > 
> > Look: we have 3 choices: to check or not to check, and if we are
> > checking whether it is under #ifdef DEBUG. Not checking at all makes the
> > code inconsistent with the check in periodic_usecs(). Then, if we are
> > checking, putting it under #ifdef DEBUG goes against minimum complexity /
> > "to add as little code as possible ...". It looks the good balance is to
> > leave the checking as is module you above remark.
> > 
> > And with the above-mentioned correction and comments inspired by Sarah's
> > concern I'm resending the whole series as v3. Can we do it this way,
> > please?
> 
> Okay, you can add my Acked-by to the 2/2 patch.

Thanks a lot!

By the way, is it "Acked-off-by" (as you wrote for 1/2) or "Acked-by"
(as you write here)?


Thanks again,
Kirill
