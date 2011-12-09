Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1LIAqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:46:44 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25782 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753057Ab1LIAqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:46:38 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18yBPYqwnr2ajHZJOtky9U+
Date: Thu, 8 Dec 2011 16:45:07 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Weber <weber@corscience.de>
Cc: trivial@kernel.org, jkosina@suse.cz, Russell King <linux@arm.linux.org.uk>,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        uwe.kleine-koenig@pengutronix.de
Subject: Re: [PATCHv2] ARM: OMAP: hsmmc: Fix mux for non-OMAP pins
Message-ID: <20111209004507.GJ31337@atomide.com>
References: <1321565988-4511-1-git-send-email-weber@corscience.de>
 <1321565988-4511-3-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321565988-4511-3-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Weber <weber@corscience.de> [111117 13:05]:
> The Devkit8000 uses a TWL4030 pin for card detection.
> Thats why the error:
> _omap_mux_init_gpio: Could not set gpio192
> occurs.
> 
> This patch checks that the pin is on OMAP before
> calling omap_mux_init_gpio.

Thanks applying into omap driver branch.

Tony
