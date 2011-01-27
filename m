Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1A0QBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:01:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48662 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752539Ab1A0QBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:01:48 -0500
Date: Thu, 27 Jan 2011 11:01:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert Morell <rmorell@nvidia.com>
cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>, Olof Johansson <olof@lixom.net>,
        Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/3] USB: HCD: Add driver hooks for (un)?map_urb_for_dma
In-Reply-To: <1296097609-32302-3-git-send-email-rmorell@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1101271101310.2090-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Robert Morell wrote:

> Provide optional hooks for the host controller driver to override the
> default DMA mapping and unmapping routines.  In general, these shouldn't
> be necessary unless the host controller has special DMA requirements,
> such as alignment contraints.  If these are not specified, the
> general usb_hcd_(un)?map_urb_for_dma functions will be used instead.
> Also, pass the status to unmap_urb_for_dma so it can know whether the
> DMA buffer has been overwritten.
> 
> Finally, add a flag to be used by these implementations if they
> allocated a temporary buffer so it can be freed properly when unmapping.
> 
> Signed-off-by: Robert Morell <rmorell@nvidia.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

