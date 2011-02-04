Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1BDUSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:18:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:43267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab1BDUSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:18:04 -0500
Date: Fri, 4 Feb 2011 12:16:16 -0800
From: Greg KH <gregkh@suse.de>
To: Olof Johansson <olof@lixom.net>
Cc: Greg KH <greg@kroah.com>, Robert Morell <rmorell@nvidia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 3/3] USB: ehci: tegra: Align DMA transfers to 32 bytes
Message-ID: <20110204201616.GA12482@suse.de>
References: <1295559715-14264-1-git-send-email-rmorell@nvidia.com>
 <1296097609-32302-4-git-send-email-rmorell@nvidia.com>
 <20110204194954.GA25180@kroah.com>
 <AANLkTinRtch4Pvr3GLz5wZU2xkG3FMJxxzSNAdParA7j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinRtch4Pvr3GLz5wZU2xkG3FMJxxzSNAdParA7j@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 12:14:54PM -0800, Olof Johansson wrote:
> On Fri, Feb 4, 2011 at 11:49 AM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Jan 26, 2011 at 07:06:49PM -0800, Robert Morell wrote:
> >> The Tegra2 USB controller doesn't properly deal with misaligned DMA
> >> buffers, causing corruption.  This is especially prevalent with USB
> >> network adapters, where skbuff alignment is often in the middle of a
> >> 4-byte dword.
> >>
> >> To avoid this, allocate a temporary buffer for the DMA if the provided
> >> buffer isn't sufficiently aligned.
> >>
> >> Signed-off-by: Robert Morell <rmorell@nvidia.com>
> >> ---
> >>  drivers/usb/host/ehci-tegra.c |   90 +++++++++++++++++++++++++++++++++++++++++
> >
> > This file doesn't seem to be in any tree that I can find, including my
> > own, so I can't apply this patch.
> >
> > What am I supposed to do with it?
> 
> It hasn't been posted for upstream yet, so nothing for you to do. The
> driver will be posted for review soon, hopefully in time for .39.

Then why would someone send me a patch for it already?

Still confused,

greg k-h
