Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1LEVFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:05:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab1LEVFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:05:47 -0500
Date: Mon, 5 Dec 2011 13:02:09 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, sgruszka@redhat.com, IvDoorn@gmail.com,
        linville@tuxdriver.com, stable@vger.kernel.org
Subject: Re: Patch "rt2800pci: handle spurious interrupts" has been added to
 the 3.1-stable tree
Message-ID: <20111205210209.GB26148@suse.de>
References: <13228684624108@kroah.org>
 <201112030350.16436.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112030350.16436.s.L-H@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 03:50:14AM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Saturday 03 December 2011, gregkh@suse.de wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     rt2800pci: handle spurious interrupts
> > 
> > to the 3.1-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      rt2800pci-handle-spurious-interrupts.patch
> > and it can be found in the queue-3.1 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> > From 4ba7d9997869d25bd223dea7536fc1ce9fab3b3b Mon Sep 17 00:00:00 2001
> > From: Stanislaw Gruszka <sgruszka@redhat.com>
> > Date: Wed, 16 Nov 2011 11:09:17 +0100
> > Subject: rt2800pci: handle spurious interrupts
> [...]
> 
> This patch has been reverted again, due to 
> http://patchwork.ozlabs.org/patch/127153/

Thanks for letting me know, it's now reverted.

greg k-h
