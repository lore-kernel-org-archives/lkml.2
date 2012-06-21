Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab2FUOqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 10:46:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60795 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab2FUOqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 10:46:17 -0400
Date: Thu, 21 Jun 2012 07:46:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Thunderbolt, Apple Monitor & MBA, and excess kworker load
Message-ID: <20120621144613.GD1818@kroah.com>
References: <20120620154842.GA5788@air.dominikbrodowski.net>
 <20120620155626.GA3384@kroah.com>
 <20120620161012.GK7170@phenom.ffwll.local>
 <20120621105900.GA5934@air.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120621105900.GA5934@air.dominikbrodowski.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 12:59:00PM +0200, Dominik Brodowski wrote:
> 
> On Wed, Jun 20, 2012 at 06:10:12PM +0200, Daniel Vetter wrote:
> > On Wed, Jun 20, 2012 at 08:56:26AM -0700, Greg KH wrote:
> > > On Wed, Jun 20, 2012 at 05:48:42PM +0200, Dominik Brodowski wrote:
> > > > Hi,
> > > > 
> > > > At work, I wish to attach a 27" Apple Display using thunderbolt to my Mac
> > > > Book Air 4,2 13". Using OS X, it works fine, but as I prefer using Linux, I
> > > > tested out Ubuntu's stock kernel and (among other) 3.5.0-rc3+ as of f40759e.
> > > > Hotplug doesn't work (known issue), but also with coldplug the display
> > > > reacts _very_ slow, way too slow for real use: The screen updates only every
> > > > half second or so. Is this a known bug? Might something go afoul with
> > > > kworker -- they need about 75% of the CPU with the large display attached,
> > > > and less than 1% _without_ the large display.
> > > 
> > > It's not really a known bug, but it is known that Thunderbolt doesn't
> > > work all that well, if at all, in Linux due to the BIOS issues that you
> > > have run into (the hotplug stuff.)
> 
> Is there anything where I could help?

If you can figure out how Apple implemented this with their custom ACPI
interface, that would be most helpful.  I have a Thunderbolt machine on
order and will start to work on this in a month or so when I receive it.

thanks,

greg k-h
