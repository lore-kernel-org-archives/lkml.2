Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1GHVlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:41:23 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38638 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754290Ab1GHVlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:41:21 -0400
X-Sasl-enc: aRWL7EMoFGBuiF3WsqrFAJjIQuT+rByrvLw0VrTBXaRY 1310161280
Date: Fri, 8 Jul 2011 14:36:04 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Greg KH <gregkh@suse.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] tty/serial: tegra: Use engineering names in DT
 compatible property
Message-ID: <20110708213604.GB31866@kroah.com>
References: <1309896461-21976-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309896461-21976-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 02:07:41PM -0600, Stephen Warren wrote:
> Engineering names are more stable than marketing names. Hence, use them
> for Device Tree compatible properties instead.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Greg, This builds on patches Grant has (or has said he will have) in his
> devicetree/next branch, so I assume this change would be merged through
> the same route.

Sounds reasonable.  Grant, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch when you apply it.

thanks,

greg k-h
