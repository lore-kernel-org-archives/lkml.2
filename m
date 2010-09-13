Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0IMSNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:13:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab0IMSNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:13:21 -0400
Date: Mon, 13 Sep 2010 11:13:14 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        stable@kernel.org, lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>, Phil Dibowitz <phil@ipom.com>
Subject: Re: Linux 2.6.34.7
Message-ID: <20100913181314.GA16248@suse.de>
References: <20100913170515.GA8943@kroah.com>
 <AANLkTinA30LGPUMrL_5tLaB+rLUAv7AAutZwiZCW2qJJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinA30LGPUMrL_5tLaB+rLUAv7AAutZwiZCW2qJJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:41:37AM -0700, Linus Torvalds wrote:
> On Mon, Sep 13, 2010 at 10:05 AM, Greg KH <gregkh@suse.de> wrote:
> >
> > It fixes a single bug that a number of users have reported in that their
> > USB devices no longer work properly.  Sometimes it causes lost
> > keystrokes, and other times X refuses to boot as it can not communicate
> > properly with some tablet devices.
> 
> So just out of interest, why is that commit ok and doesn't need to be
> reverted in 36-rc? The comments in the commit message do not explain.

Yes, the usb suspend logic changed in .35 and it's not needed to be
reverted in .35 or .36, or even in .32.  So it's all safe in the other
kernel versions.

Alan, if this is incorrect, please let me know.

thanks,

greg k-h
