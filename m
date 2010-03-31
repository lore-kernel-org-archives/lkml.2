Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0CaUhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 16:37:22 -0400
Received: from kroah.org ([198.145.64.141]:46670 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757954Ab0CaUhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 16:37:20 -0400
Date: Wed, 31 Mar 2010 13:34:47 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gamil.com>, dri-devel@lists.sourceforge.net,
       Dave Airlie <airlied@gmail.com>, stable@kernel.org
Subject: Re: [stable] [Regression, post-rc2] Commit a5ee4eb7541 breaks
	OpenGL on RS780 (was: Re: Linux 2.6.34-rc3)
Message-ID: <20100331203447.GA13360@kroah.com>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <201003302316.45651.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003302316.45651.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 11:16:45PM +0200, Rafael J. Wysocki wrote:
> On Tuesday 30 March 2010, Linus Torvalds wrote:
> ...
> > Other than that? Random fixes and updates all over. Mostly drivers and 
> > filesystems, and mostly fairly small things. If you had PCI resource 
> > conflict problems with the early -rc's due to the _CRS window thing, for 
> > example, that should hopefully be fixed. See the appended shortlog for 
> > other details.
> 
> ...
> 
> > Clemens Ladisch (4):
> >       firewire: core: fw_iso_resource_manage: fix error handling
> >       firewire: ohci: add cycle timer quirk for the TI TSB12LV22
> >       ALSA: cmipci: work around invalid PCM pointer
> >       PCI quirk: RS780/RS880: work around missing MSI initialization
> 
> This one (commit a5ee4eb7541) broke OpenGL acceleration on my new test box
> which happens to have a RS780.
> 
> The symptom is that every operation involving the GPU is _very_ slow, so the
> window manager eventually disables compositing.  Reverting this commit makes
> things work flawlessly again.
> 
> So, please revert.
> 
> BTW, I don't think it's a -stable material.

Ok, I'll go drop it.

thanks,

greg k-h
