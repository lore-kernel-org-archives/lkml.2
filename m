Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab0DMN1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 09:27:34 -0400
Received: from kroah.org ([198.145.64.141]:55372 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab0DMN1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:27:33 -0400
Date: Tue, 13 Apr 2010 06:28:02 -0700
From: Greg KH <greg@kroah.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33.2 does not boot on Atom?
Message-ID: <20100413132802.GC15247@kroah.com>
References: <20100406205509.GA12034@linux-m68k.org> <20100412061604.GB31112@kroah.com> <20100413090952.GA17227@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413090952.GA17227@linux-m68k.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:09:52AM +0200, Richard Zidlicky wrote:
> On Sun, Apr 11, 2010 at 11:16:05PM -0700, Greg KH wrote:
> > On Tue, Apr 06, 2010 at 10:55:09PM +0200, Richard Zidlicky wrote:
> > > Hi,
> > > 
> > > I have been compiling my own kernels since ages and switched from 2.6.32.8 to 
> > > 2.6.33.2 now.
> > > Same procedure like allways - copied .config to new buildtree, make menuconfig
> > > (almost nothing changed in config), installed the new kernel on 2 machines.
> > 
> > Oops, that's the problem, you need to do 'make oldconfig' to ensure you
> > didn't miss anything, and to adjust any new defaults.
> 
> I can confirm that "make oldconfig" does not fix the problem.
> 
> Grub appears to load the kernel (at least it does not come back with an error as it otherwise
> would), cursor in the topleft corner and absolutely no activity. 
> no reaction to ctrl-alt-del or magic keys. For all other kernels I would see at least the
> "uncompressing kerne.." message, not here.

Try asking on a Fedora kernel list as this might just be a config issue
with the way modesetting is set up.

good luck,

greg k-h
