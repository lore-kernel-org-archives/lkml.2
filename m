Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1DRGCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 02:02:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:36533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1DRGCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 02:02:11 -0400
Date: Sun, 17 Apr 2011 23:02:55 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arjan Mels <arjan.mels@gmx.net>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>,
        Max Vozeler <max@vozeler.com>
Subject: Re: [12/74] staging: usbip: bugfixes related to kthread conversion
Message-ID: <20110418060255.GC22168@suse.de>
References: <20110413155144.231263288@clark.kroah.org>
 <201104172215.01736.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104172215.01736.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 10:15:01PM +0200, Arnd Bergmann wrote:
> On Wednesday 13 April 2011, Greg KH wrote:
> > From: Arjan Mels <arjan.mels@gmx.net>
> > 
> > commit d2dd0b07c3e725d386d20294ec906f7ddef207fa upstream.
> > 
> > When doing a usb port reset do a queued reset instead to prevent a
> > deadlock: the reset will cause the driver to unbind, causing the
> > usb_driver_lock_for_reset to stall.
> > 
> > Signed-off-by: Arjan Mels <arjan.mels@gmx.net>
> > Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
> > Cc: Max Vozeler <max@vozeler.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> 
> I think either the subject line is misleading or the patch is not
> needed in -stable. The kthread conversion was done in 2.6.38, so
> any bug introduced by it would not need to be fixed in an earlier
> version, afaict.

Yes, the Subject: was incorrect, and I only realized it after it was
committed to the tree, sorry.

The bug fixes were still real.

thanks,

greg k-h
