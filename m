Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1E0JJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:09:35 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26465 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752369Ab1E0JJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:09:34 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 27 May 2011 17:11:58 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <patches@linaro.org>,
        <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH 2/3] ARM: mxs: add gpio-mxs platform devices
Message-ID: <20110527091158.GD30146@S2100-06.ap.freescale.net>
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org>
 <201105201223.00427.arnd@arndb.de>
 <20110520140316.GA27551@S2100-06.ap.freescale.net>
 <201105201623.40990.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201105201623.40990.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 04:23:40PM +0200, Arnd Bergmann wrote:
[...]
> No, this would put all gpio devices below the top-level /sys/devices/platform
> directory, where they certainly don't belong. Please find a proper
> place and put them there.
> 
To make it clear, which one is the best to have all gpio devices below?

 * /sys/devices/platform/gpio-mxs
 * /sys/devices/platform/mxs
 * /sys/devices/platform/mxs/gpio

-- 
Regards,
Shawn

