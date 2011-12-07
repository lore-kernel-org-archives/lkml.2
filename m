Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1LGNFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:05:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:59082 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab1LGNFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:05:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,313,1320652800"; 
   d="scan'208";a="99612429"
Date: Wed, 7 Dec 2011 15:05:17 +0200
From: Heikki Krogerus <krohei@gmail.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
Message-ID: <20111207130517.GA22946@xps8300>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
 <1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 05, 2011 at 07:23:40PM +0200, Felipe Contreras wrote:
> From: Felipe Contreras <felipe.contreras@gmail.com>
> 
> This reverts commit 10299e2e4e3ed3b16503d4e04edd48b33083f4e2.
> 
> This seems to break USB networking stuff.
> 
> Cc: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
> Cc: Heikki Krogerus <heikki.krogerus@nokia.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |   27 +------------------------
>  1 files changed, 2 insertions(+), 25 deletions(-)

<snip>

> -static void __init rx51_charger_init(void)
> -{
> -	WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
> -		GPIOF_OUT_INIT_LOW, "isp1704_reset"));

How about simply GPIOF_OUT_INIT_HIGH here. Is that not enough to fix
your problem? Revering the whole thing does not make any sense to me.

-- 
heikki
