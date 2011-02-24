Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1BXAkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:40:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab1BXAkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:40:22 -0500
Date: Wed, 23 Feb 2011 16:40:13 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Matthew Garrett <mjg@redhat.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: btusb autosuspend (was Re: Linux 2.6.38-rc6)
Message-ID: <20110224004013.GA1874@suse.de>
References: <AANLkTimTzjHkVQGPBRXrcb6M1_xaDY_==pB5ZyB9CJpR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTzjHkVQGPBRXrcb6M1_xaDY_==pB5ZyB9CJpR@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 04:25:23PM -0800, Linus Torvalds wrote:
> Hmm. Is there any reason we shouldn't revert commit
> 556ea928f78a390fe16ae584e6433dff304d3014 given the regression?
> 
> It apparently had problems before too, and caused autosuspend to be
> disabled entirely, judging at least by
> 
>   https://bugzilla.redhat.com/show_bug.cgi?id=528744
> 
> but there's obviously the comment about "those should be fixed now".
> Apparently there are more issues.
> 
> I have no idea whether this is a USB-level issue, or a driver-level
> one. There are no comments about exactly what fixed the input device
> issues. So I'm adding both BT and USB people to the discussion.

I think we should revert it as it looks like there is hardware out there
that can not handle this always being enabled :(

Unless Matthew has a fix for this already?

thanks,

greg k-h
