Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab2JGIXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 04:23:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47717 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2JGIXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 04:23:15 -0400
Date: Sun, 7 Oct 2012 09:23:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: OMAP: Fix dependency for OMAP_DEBUG_LEDS
Message-ID: <20121007082303.GD28061@n2100.arm.linux.org.uk>
References: <1349596837.15349.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349596837.15349.2.camel@phoenix>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 04:00:37PM +0800, Axel Lin wrote:
>  config OMAP_DEBUG_LEDS
> -	def_bool y if NEW_LEDS
> +	default y if LEDS_CLASS
>  	depends on OMAP_DEBUG_DEVICES

This change is wrong.  You're making this config entry untyped.
