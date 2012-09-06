Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab2IFQWC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:22:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45461 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab2IFQV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:21:58 -0400
Date: Thu, 6 Sep 2012 09:18:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Message-ID: <20120906161835.GA7923@kroah.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:45:19PM +0300, Felipe Balbi wrote:
> Hi guys,
> 
> here's v4 of the omap uart patchset. No changes other than a rebase on top of
> Greg's tty-next branch and Tony's Acked-by being added to a couple patches
> 
> Note: I'm resending the series with Vikram's Software Flow Control fix anyway
> as it can just be ignored if it's decided it needs to go into this merge
> window.
> 
> Changes since v3:
> 	. Rebased on top of Greg's tty-next branch
> 	. Added Tony's Acked-by

Thanks for rebasing, all now applied.

greg k-h
