Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab2CaBO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 21:14:58 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:48553 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759329Ab2CaBOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 21:14:36 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 108.39.66.94
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ggRT855JUTIw44zOGNZCs13hCS7gxmRo=
Date: Fri, 30 Mar 2012 21:14:32 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH RFT v3] watchdog: Convert orion_wdt driver to watchdog
 core
Message-ID: <20120331011432.GG7274@titan.lakedaemon.net>
References: <1332804040.5294.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332804040.5294.2.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 07:20:40AM +0800, Axel Lin wrote:
> Convert orion_wdt driver to use watchdog framework API.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi Jason, Andrew,
> I don't have this hardware handy.
> I'd appreciate if you can review and test this patch.

Axel,

Sorry for the delay, been a busy week.  I'm getting the following error:

drivers/watchdog/orion_wdt.c:133:2: error: unknown field 'get_timeleft'
specified in initializer
drivers/watchdog/orion_wdt.c:133:2: warning: initialization from
incompatible pointer type

What tag did you base this off of?  Are there any dependencies not in
mainline?

I based off of v3.3 with the following merged:

git://git.infradead.org/users/jcooper/linux-kirkwood.git kirkwood_dt_for_3.4_v3

thx,

Jason.
