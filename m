Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab1ELJkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:40:10 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35880 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753407Ab1ELJkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:40:08 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dj2UXgdTg/fiWJpa13MB9
Date: Thu, 12 May 2011 02:40:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110512094001.GH31483@atomide.com>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
 <20110512074421.GA2429@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512074421.GA2429@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sascha Hauer <s.hauer@pengutronix.de> [110512 00:40]:
> 
> These all basically describe the same thing: put pad x into one of modes
> a, b, c and apply certain flags like drive strength on this.
> 
> the other class of pin muxing I know of is that a whole group of pads
> can be switched to a particular mode using a mux register like I think
> is used used in your ux300 driver.
> 
> I'd like to have a unified way to describe this. If we ever want to move
> this into the device tree we need this anyway as I think it's not an
> option to have completely different SoC specific descriptions in the
> device tree.

Me too. Otherwise we'll have multiple different device tree implementations.

We might as well have the data in suitable format for device tree to
start with, and then have common access functions that can be replaced
for various platforms if necessary.

Regards,

Tony
