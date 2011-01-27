Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1A0QBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:01:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48636 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751812Ab1A0QBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:01:07 -0500
Date: Thu, 27 Jan 2011 11:01:06 -0500 (EST)
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
Subject: Re: [PATCH 1/3] USB: HCD: Add usb_hcd prefix to exported functions
In-Reply-To: <1296097609-32302-2-git-send-email-rmorell@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1101271100410.2090-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Robert Morell wrote:

> The convention is to prefix symbols exported from the USB HCD core with
> "usb_hcd".  This change makes unmap_urb_setup_for_dma() and
> unmap_urb_for_dma() consistent with that.
> 
> Signed-off-by: Robert Morell <rmorell@nvidia.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

