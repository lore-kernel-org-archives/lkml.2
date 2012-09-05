Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab2IEUaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:30:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56287 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566Ab2IEUaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:30:21 -0400
X-Sasl-enc: bDm11StK4euyjW26qFtQS8qboeI7gnl1j4Zq91U9Kr0T 1346877020
Date: Wed, 5 Sep 2012 13:27:49 -0700
From: Greg KH <greg@kroah.com>
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
        Sourav Poddar <sourav.poddar@ti.com>,
        Vikram Pandita <vikram.pandita@ti.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 20/23] serial: omap: fix software flow control
Message-ID: <20120905202749.GA2451@kroah.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
 <1345717983-18179-21-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345717983-18179-21-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 01:33:00PM +0300, Felipe Balbi wrote:
> From: Vikram Pandita <vikram.pandita@ti.com>
> 
> Software flow control register bits were not defined correctly.
> 
> Also clarify the IXON and IXOFF logic to reflect what userspace wants.
> 
> Cc: stable@vger.kernel.org
> Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---

If this is a stable patch, should it be pulled out and put also in for
3.6?

thanks,

greg k-h
