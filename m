Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab1JFTii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:38:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:29776 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758742Ab1JFTig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:38:36 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/CgWuKTAFdM+CHRrhuuNED
Date: Thu, 6 Oct 2011 12:38:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: Re: [PATCH 0/2] AM3517EVM: Add support for MMC1
Message-ID: <20111006193832.GL6324@atomide.com>
References: <1313754751-11752-1-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313754751-11752-1-git-send-email-abhilash.kv@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Abhilash K V <abhilash.kv@ti.com> [110819 04:19]:
> This patch-set adds support for MMC1 slot on the 
> AM3517 EVM's base-board.
> These patches are dependent on the following patch-set
> http://marc.info/?l=linux-omap&m=131247357813228&w=2
> which gets the AM3517 EVM booting.
> 
> The patches are tested on master of tmlind/linux-omap-2.6.git.
> Kernel version is 3.0.0-rc7 and last commit on top of which these patches
> were added is:
> 
>         885cf6ff7d3dad4cc44be74b0577d3a554d3ab71: Linux-omap rebuilt:
>         Updated to -rc7, added new boards
> 
> Cc: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
> Abhilash K V (1):
>   AM3517: Support for MMC1
> 
> Vaibhav Hiremath (1):
>   AM3517EVM: Add support for base-board MMC slot
> 
>  arch/arm/mach-omap2/board-am3517evm.c |   22 ++++++++++++++++++++++
>  arch/arm/mach-omap2/hsmmc.c           |   10 +++++++++-
>  2 files changed, 31 insertions(+), 1 deletions(-)
> 

Adding these both to board branch thanks.

Tony
