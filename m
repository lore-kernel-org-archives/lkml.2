Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab2CGRvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:51:16 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:41338 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2CGRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:51:13 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rsB4aIEVPe73ta2PokY3o
Date: Wed, 7 Mar 2012 09:51:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Sekhar Nori <nsekhar@ti.com>, Jamie Iles <jamie@jamieiles.com>,
        Kevin Hilman <khilman@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Barry Song <baohua.song@csr.com>, Eric Miao <eric.y.miao@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jiandong Zheng <jdzheng@broadcom.com>,
        Colin Cross <ccross@android.com>, Shawn Guo <shawn.guo@linaro.org>,
        Roland Stigge <stigge@antcom.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Pre-merge-window status of the arm-soc tree
Message-ID: <20120307175100.GH12083@atomide.com>
References: <201203062054.55434.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203062054.55434.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd & Olof,

* Arnd Bergmann <arnd@arndb.de> [120306 12:26]:
> 
> * Russell now has a branch that contains patches from his tree that
> directly impact stuff in arm-soc. We had a lot of nasty conflicts
> the last time around, which resulted in some of the patches from
> arm-soc not making it in during the merge window. Pulling the
> rmk/for-armsoc branch into arm-soc hopefully lets us avoid this
> situation in the future because we will fix the conflicts much
> earlier.

There's also two urgent issues pending for omap in case you
are filtering mails on keywords to make them safe to read :)

See this:

http://www.spinics.net/lists/arm-kernel/msg163661.html

Also, after that is out of the way, I have two more pull request
ready for fixes for various build and warning issues Russell
has reported.

Regards,

Tony 
