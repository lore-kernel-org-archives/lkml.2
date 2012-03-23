Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2CWR35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:29:57 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:26717 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab2CWR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:29:56 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX184gqntq4n4P3CqqsbgsE9j
Date: Fri, 23 Mar 2012 10:29:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: mathieu.poirier@linaro.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 3/9] ARM: omap2/n8x0: work around modular omap mmc
Message-ID: <20120323172953.GD9859@atomide.com>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
 <1332522836-29517-4-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332522836-29517-4-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> [120323 10:16]:
> From: Russell King <linux@arm.linux.org.uk>
> 
> When the omap driver is built as a module for n8x0,
> n8x0_mmc_set_power_menelaus cannot call into the driver:
> 
> arch/arm/mach-omap2/board-n8x0.c:374: undefined reference
> to `omap_mmc_notify_cover_event'
> 
> As a workaround, do not provide that device in this case. This needs
> to be fixed properly, e.g. by converting n8x0 to be probed through the
> device tree and moving that code into the driver.

This too should be fixed now in a way where just the cover events
won't work if compiled as a module.

Regards,

Tony
