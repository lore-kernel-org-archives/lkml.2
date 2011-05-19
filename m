Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab1ESNwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:52:09 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:18888
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933192Ab1ESNwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:52:07 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz9371O1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 19 May 2011 21:56:32 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Message-ID: <20110519135631.GB26816@S2100-06.ap.freescale.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
 <20110519085638.GA26816@S2100-06.ap.freescale.net>
 <BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 02:21:27PM +0200, Linus Walleij wrote:
> On Thu, May 19, 2011 at 10:56 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> 
> > I start working on moving mxs gpio (arch/arm/mach-mxs/gpio.c) into
> > driver/gpio, and I see the possibility to go a different approach
> > from U300 one posted here.
> 
> I've tried to figure out what relation the mail has to the U300 driver
> but cannot find any, more than that it's moving a driver... Please
> start a new mail thread.
> 
I will post mxs-gpio driver once I get it done.  Then please review
the code and see the difference between mxs-gpio and u300-gpio,
though these hardwares have something in common.

-- 
Regards,
Shawn

