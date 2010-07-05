Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0GEM5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:57:39 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61195 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0GEM5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:57:37 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/tDTFE/J3HZcEpridfvB5b
Date: Mon, 5 Jul 2010 15:57:16 +0300
From: Tony Lindgren <tony@atomide.com>
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, Kan-Ru Chen <kanru@0xlab.org>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 04/11] OMAP2: Devkit8000: Setup LCD reset
Message-ID: <20100705125714.GW15951@atomide.com>
References: <1275478671-24563-1-git-send-email-weber@corscience.de>
 <1275478671-24563-5-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275478671-24563-5-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Weber <weber@corscience.de> [100602 14:33]:
> From: Kan-Ru Chen <kanru@0xlab.org>
> 
> This patch corrects the LCD reset pin configuration.
> 
> Original code from early devkit8000 patch sets the TWL4030 GPIO_1
> to EHCI_nOC and TWL4030_GPIO_MAX+1 to ledA. Indeed these two pins
> are both LCD_PWREN. Setup the lcd reset_gpio properly so it can be
> disabled when other display is turned on.

Applied this and the rest of the series too.

Tony
