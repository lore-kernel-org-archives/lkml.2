Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0LFXWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:22:19 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37210 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0LFXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:22:17 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18se2skckMSApjg/0Oh40qc
Date: Mon, 6 Dec 2010 15:21:59 -0800
From: Tony Lindgren <tony@atomide.com>
To: David Sin <davidsin@ti.com>
Cc: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lajos Molnar <molnar@ti.com>
Subject: Re: [PATCH 7/9] TILER-DMM: Main TILER driver implementation
Message-ID: <20101206232159.GS8345@atomide.com>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
 <1291674446-10766-8-git-send-email-davidsin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291674446-10766-8-git-send-email-davidsin@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* David Sin <davidsin@ti.com> [101206 14:09]:
> From: Lajos Molnar <molnar@ti.com>
> 
> This patch contains the TILER driver and implementation of the TILER
> block manipulation and mapping functions.
> 
> It also contains the makefile and config file for the TILER driver.

...
> +config TILER_GRANULARITY
> +        int "Allocation granularity"
> +        range 1 4096
> +        default 128
...
> +config TILER_ALIGNMENT
> +        int "Allocation alignment"
> +        range 1 4096
> +        default 4096
...
> +config TILER_CACHE_LIMIT
> +        int "Memory limit to cache free pages in MBytes"
> +        range 0 128
> +        default 40
...

Do you really need these Kconfig options? To me it seems you
should pass these in platform_data.

Regards,

Tony
