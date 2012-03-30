Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474Ab2C3QL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:11:58 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:43853 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2C3QLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:11:41 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/F5XiV0nc8FFn0S+8wsClZ
Date: Fri, 30 Mar 2012 09:11:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kernel@pengutronix.de, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Barry Song <baohua.song@csr.com>, Andrew Lunn <andrew@lunn.ch>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 03/17] ARM: mark const init data with __initconst
 instead of __initdata
Message-ID: <20120330161130.GA8240@atomide.com>
References: <20120329211131.GA31250@pengutronix.de>
 <1333055554-31300-3-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1333055554-31300-3-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Uwe Kleine-König <u.kleine-koenig@pengutronix.de> [120329 14:16]:
> As long as there is no other non-const variable marked __initdata in the
> same compilation unit it doesn't hurt. If there were one however
> compilation would fail with
> 
> 	error: $variablename causes a section type conflict
> 
> because a section containing const variables is marked read only and so
> cannot contain non-const variables.

Acked-by: Tony Lindgren <tony@atomide.com>
