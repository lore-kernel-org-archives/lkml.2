Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1BDT7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:59:12 -0500
Received: from kroah.org ([198.145.64.141]:37338 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab1BDT7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:59:08 -0500
Date: Fri, 4 Feb 2011 11:49:54 -0800
From: Greg KH <greg@kroah.com>
To: Robert Morell <rmorell@nvidia.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>, Olof Johansson <olof@lixom.net>,
        Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 3/3] USB: ehci: tegra: Align DMA transfers to 32 bytes
Message-ID: <20110204194954.GA25180@kroah.com>
References: <1295559715-14264-1-git-send-email-rmorell@nvidia.com>
 <1296097609-32302-4-git-send-email-rmorell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296097609-32302-4-git-send-email-rmorell@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 07:06:49PM -0800, Robert Morell wrote:
> The Tegra2 USB controller doesn't properly deal with misaligned DMA
> buffers, causing corruption.  This is especially prevalent with USB
> network adapters, where skbuff alignment is often in the middle of a
> 4-byte dword.
> 
> To avoid this, allocate a temporary buffer for the DMA if the provided
> buffer isn't sufficiently aligned.
> 
> Signed-off-by: Robert Morell <rmorell@nvidia.com>
> ---
>  drivers/usb/host/ehci-tegra.c |   90 +++++++++++++++++++++++++++++++++++++++++

This file doesn't seem to be in any tree that I can find, including my
own, so I can't apply this patch.

What am I supposed to do with it?

confused,

greg k-h
