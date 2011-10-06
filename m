Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab1JFTvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:51:39 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39715 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759181Ab1JFTvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:51:37 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX184xNH/Uwhm+xfKiU74ozpW
Date: Thu, 6 Oct 2011 12:51:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP2: Devkit8000: Remove double omap_mux_init_gpio
Message-ID: <20111006195134.GN6324@atomide.com>
References: <1315321909-5593-1-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315321909-5593-1-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Weber <weber@corscience.de> [110906 07:38]:
> Remove the init of card detect pin because
> omap_mux_init_gpio() is called during hsmmc initialization
> for the write protect and card detect pin.

Thanks, adding this into fixes-part2 branch.

Tony
