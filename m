Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0LGU1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:27:06 -0500
Received: from kroah.org ([198.145.64.141]:36155 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab0LGU0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:26:45 -0500
Date: Tue, 7 Dec 2010 12:20:18 -0800
From: Greg KH <greg@kroah.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.36.1
Message-ID: <20101207202018.GB11264@kroah.com>
References: <20101122191831.GG4340@kroah.com>
 <201011231343.21778.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011231343.21778.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 01:43:09PM +0100, Martin Steigerwald wrote:
> Am Montag 22 November 2010 schrieb Greg KH:
> > I'm announcing the release of the 2.6.36.1 kernel.
> > 
> > All users of the 2.6.36 kernel series must upgrade.
> > 
> > The updated 2.6.36.y git tree can be found at:
> >        
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.36.y.gi
> > t and can be browsed at the normal kernel.org git web browser:
> >        
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=
> > summary
> 
> I am missing 
> 
> drm/radeon/kms: MC vram map needs to be >= pci aperture size
> b7d8cce5b558e0c0aa6898c9865356481598b46d
> 
> from Alex Deucher which fixes
> 
> Bug 28402 - random radeon/kms/drm related freezes with kernel 2.6.34 
> https://bugs.freedesktop.org/show_bug.cgi?id=28402
> 
> random - possibly Radeon DRM KMS related - freezes
> https://bugzilla.kernel.org/show_bug.cgi?id=16376
> 
> which according should have been queued for stable[1]
> 
> [1] https://bugs.freedesktop.org/show_bug.cgi?id=28402#c96

It's now in this next release.

thanks,

greg k-h
