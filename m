Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab0KROze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:55:34 -0500
Received: from kroah.org ([198.145.64.141]:59987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab0KROzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:55:33 -0500
Date: Thu, 18 Nov 2010 06:51:37 -0800
From: Greg KH <greg@kroah.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20101118145137.GA16565@kroah.com>
References: <1289916492-28402-1-git-send-email-tlinder@codeaurora.org> <20101117213535.GD10541@kroah.com> <000001cb870f$efbc8600$cf359200$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cb870f$efbc8600$cf359200$@org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top


On Thu, Nov 18, 2010 at 01:01:17PM +0200, Tanya Brokhman wrote:
> Hi Greg
> 
> Thank you for your comments. Please see my answers inline.

Please fix your email client (i.e. get one that works properly) so that
it quotes things correctly.  If you are going to be able to keep up with
kernel development, either install the outlook plugin that handles this
type of thing, or switch to a sane email client please.

> >   *
> >   * Copyright (C) 2003 David Brownell
> >   * Copyright (C) 2003-2005 Alan Stern
> > + * Copyright (C) 2010 Code Aurora Forum. All rights reserved.
> 
> Does your lawyers agree that this is correct to add based on the size of
> the file?  Hint, it doesn't pass the rule that some lawyers I work with
> go by, so I would be surprised that it passes theirs.
> 
> Also, I didn't think that "Code Aurora Forum" was a "real" legal entity
> last time I looked, so how can it own copyrights?  Who is the "real"
> owner here?  (hint, who does your lawyers work for...)
> [Brokhman, Tanya] I was following the instructions given to me by our legal
> team but I'll forward your comment to them and ask them once more.

I would need confirmation from them to be able to accept any such thing
in the future.  Please have them contact me if they have any questions
about this.

> And finally, did you check that this code works properly and the
> existing functionlity did not break?  How?
> [Brokhman, Tanya] Of course I did. I've also uploaded a patch series that
> implements SuperSpeed support in the Gadget Framework (still waiting on
> inputs on it). I'll upload a new version of that series today, rebased on
> top of rc1. 
> I verified the dummy_hcd functionality using that patch series and of course
> tested it both with a HS device and with a SS device. 
> In order to test our development of SuperSpeed we implemented a set of
> unittests (based on GoogleTest). It includes both tests for HS and for SS
> devices. The code was verified using that test set. 

Why did you not say this in your changelog comment?  Can you point to
these unit tests for everyone to be able to verify in the future that
nothing breaks?  Perhaps you should add them to the kernel tree itself
to make it easier to keep them in sync?

thanks,

greg k-h
