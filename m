Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2ECP1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:27:14 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:20901 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab2ECP1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:27:13 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX190PVWElrvENJkVVJPV4sqB
Date: Thu, 3 May 2012 08:27:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120503152708.GC5140@atomide.com>
References: <20120502172401.GG3739@atomide.com>
 <20120503065131.GA3738@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503065131.GA3738@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120503 00:16]:
> 
> 	I really like it
> 
> 	I was working on something simillar
> 
> 	but can we split the group management so we can use it on other
> 	bindings

Hmm I'm not sure I follow on the group management splitting, can you specify
what you have in mind here?

If you mean moving more things into pinctrl fwk, then yeah I'd assume that
will happen eventually and drivers like this will end up becoming more minimal.

Regards,

Tony
