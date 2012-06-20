Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2FTP4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:56:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34162 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2FTP4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:56:33 -0400
Date: Wed, 20 Jun 2012 08:56:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: daniel.vetter@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: Thunderbolt, Apple Monitor & MBA, and excess kworker load
Message-ID: <20120620155626.GA3384@kroah.com>
References: <20120620154842.GA5788@air.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620154842.GA5788@air.dominikbrodowski.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 05:48:42PM +0200, Dominik Brodowski wrote:
> Hi,
> 
> At work, I wish to attach a 27" Apple Display using thunderbolt to my Mac
> Book Air 4,2 13". Using OS X, it works fine, but as I prefer using Linux, I
> tested out Ubuntu's stock kernel and (among other) 3.5.0-rc3+ as of f40759e.
> Hotplug doesn't work (known issue), but also with coldplug the display
> reacts _very_ slow, way too slow for real use: The screen updates only every
> half second or so. Is this a known bug? Might something go afoul with
> kworker -- they need about 75% of the CPU with the large display attached,
> and less than 1% _without_ the large display.

It's not really a known bug, but it is known that Thunderbolt doesn't
work all that well, if at all, in Linux due to the BIOS issues that you
have run into (the hotplug stuff.)

Once the device is seen, it should just work like any other PCI device,
and so, that might be a DRM driver issue somehow.

greg k-h
