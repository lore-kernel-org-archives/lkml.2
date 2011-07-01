Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1GAN3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:29:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab1GAN3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:29:42 -0400
Date: Fri, 1 Jul 2011 06:29:19 -0700
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.0-rc5+ : khubd blocked
Message-ID: <20110701132919.GB8902@suse.de>
References: <4E0DC172.9010504@tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E0DC172.9010504@tudelft.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 02:45:38PM +0200, Éric Piel wrote:
> Hello,
> I've come across to what looks like a regression in the kernel a
> few commits after 3.0-rc5.
> 
> When I turn off a usb hub, to which my mouse and keyboard are connected,
> and then turn it on again, they are not detected again. After unplugging
> it and waiting a few minutes I get a "task khubd:621 blocked for more
> than 120 seconds."
> 
> I haven't investigated much. It seems reproducible here on my x86_64
> laptop. It doesn't seem to happen on a 3.0-rc4. Maybe important, my
> kernel already has commit 2e34b429a404675dc4fc4ad2ee339eea028da3ca
> "Merge branch 'usb-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6"
> 
> Let me know if you need me to investigate more, or maybe there is
> already a fix for that bug?

Can you run 'git bisect' to track it down to the exact patch that causes
the problem?

thanks,

greg k-h
