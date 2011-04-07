Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1DGOfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:35:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47431 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755440Ab1DGOfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:35:34 -0400
Date: Thu, 7 Apr 2011 10:35:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joerg Roedel <joerg.roedel@amd.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
In-Reply-To: <1302164789-31887-1-git-send-email-joerg.roedel@amd.com>
Message-ID: <Pine.LNX.4.44L0.1104071034070.2147-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Joerg Roedel wrote:

> Booting 2.6.38 on my test machine produces a lockdep warning
> from the usb_amd_find_chipset_info() function:

When posting revised patches, you need to indicate this fact in the
email Subject: line.  For example:

	[PATCH v.2] USB host: Fix lockdep warning in AMD PLL quirk

Otherwise people reading the email won't know which patch it refers to.

Alan Stern

