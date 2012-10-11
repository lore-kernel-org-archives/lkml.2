Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab2JKSdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:33:35 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:21703 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759032Ab2JKSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:33:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19cE7ATAaBmVYfAevxGO64O
Date: Thu, 11 Oct 2012 11:33:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 25/28] leds-lp5521/5523: use new lp55xx common header
Message-ID: <20121011183326.GA2064@atomide.com>
References: <A874F61F95741C4A9BA573A70FE3998F6417685E@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6417685E@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kim, Milo <Milo.Kim@ti.com> [121005 01:26]:
>  The LP55xx common driver provides a new header, leds-lp55xx.h.
>  This driver enables removing duplicate code for both drivers and
>  making coherent driver structure.
>  LP5521 and LP5523/55231 platform data were merged into one common file.
>  Therefore, the LP5521/5523 platform code need to be fixed.

For arch/arm/mach-omap2 parts:

Acked-by: Tony Lindgren <tony@atomide.com>
