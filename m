Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab0LRRyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:54:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab0LRRyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:54:15 -0500
Date: Sat, 18 Dec 2010 09:51:53 -0800
From: Greg KH <gregkh@suse.de>
To: Robert Morell <rmorell@nvidia.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 1/2] USB: Add driver hooks for (un)?map_urb_for_dma
Message-ID: <20101218175153.GB7225@suse.de>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
 <1292636971-17701-2-git-send-email-rmorell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292636971-17701-2-git-send-email-rmorell@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 05:49:30PM -0800, Robert Morell wrote:
> These are useful in case your device has quirks involving what memory
> is and is not DMAable.

What "device"?  Please be a whole lot more descriptive here both in the
changelog commit, and in the patch below in the comments for the hooks,
exactly what these hooks are for, who should use them, and why.

thanks,

greg k-h
