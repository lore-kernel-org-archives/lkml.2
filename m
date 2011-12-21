Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1LUTrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:47:08 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36960 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab1LUTrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:47:06 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 5/7] MTD: NAND: ams-delta: use GPIO instead of custom I/O
Date: Wed, 21 Dec 2011 20:45:34 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
References: <cover.1324331816.git.jkrzyszt@tis.icnet.pl> <ebab42f6ddd313afb38b71880ac7865e4e0ceab4.1324331816.git.jkrzyszt@tis.icnet.pl> <20111221191211.GE24444@atomide.com>
In-Reply-To: <20111221191211.GE24444@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112212045.34850.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 of December 2011 at 20:12:12, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111219 14:41]:
> > Don't use Amstrad Delta custom I/O functions for controlling the device,
> > use GPIO API instead.
> > 
> > While being at it, add missing gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB).
> > 
> > Depends on patch 2/7 "ARM: OMAP1: ams-delta: convert latches to
> > basic_mmio_gpio"
> > 
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Tony Lindgren <tony@atomide.com>
> 
> Artem, care to ack this one?


BTW, following the get_maintainer.pl script suggestions, I tried to 
include Artem in the Cc: list, but that script provided me with an 
invalid Artem's email address at nokia.com, and I gave up once my email 
gateway refused to accept that message. Now I've verified that several 
half or more year old commits signed by Artem were the sources of that 
apparently outdated information. Looks like the get_maintainer.pl script 
needs improvement, or should be used with care by people who don't 
follow all email address changes ;).

Thanks,
Janusz
