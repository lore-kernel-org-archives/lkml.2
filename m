Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031996Ab2CSQZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:25:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40363 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031218Ab2CSQZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:25:21 -0400
Date: Mon, 19 Mar 2012 09:25:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, romain@orebokech.com,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [ 05/38] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120319162516.GA3694@kroah.com>
References: <20120316233447.747702375@linuxfoundation.org>
 <4F670872.2090700@suse.cz>
 <20120319154633.GA8176@kroah.com>
 <20120319160415.GE11180@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319160415.GE11180@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 11:04:16AM -0500, Jonathan Nieder wrote:
> Greg KH wrote:
> > On Mon, Mar 19, 2012 at 11:20:34AM +0100, Jiri Slaby wrote:
> 
> >> The commit below is reported to crash the machine in the early init. See
> >> the first reply to this message (lkml.org seems to be down right now):
> >> lkml.org/lkml/2012/3/18/132
> >
> > Yes, but this patch fixes machines that others have been reporting
> > problems with, so, what am I supposed to do?
> >
> > I'll stick with this patch for now, and hope that Matthew fixes this up
> > in Linus's tree and I'll suck that fix in when it gets there.  Is that
> > ok?
> 
> Just one data point from a distro perspective: regressions are way
> more painful than problems that already existed.  So it seems worth
> considering dropping the patch for now and grabbing the patch and fix
> when ready.

I think you are missing the fact that this patch itself is fixing a
regression from a previous patch :)

thanks,

greg k-h
