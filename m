Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1ELHA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:00:27 -0400
Received: from londo.lunn.ch ([80.238.139.98]:51559 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab1ELHAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:00:25 -0400
Date: Thu, 12 May 2011 09:00:14 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110512070014.GE31070@lunn.ch>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
 <20110503172712.GE6538@lunn.ch>
 <BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
 <20110511095031.GD31070@lunn.ch>
 <BANLkTikTVEAWEjWV8da0Vq1vvOUDHa4FVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikTVEAWEjWV8da0Vq1vvOUDHa4FVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > To me, it makes more sense that drivers/pinmux/kirkwood.c provides the
> > unique pin functions, where there are no alternatives, eg the twi
> > 0. It could also provide the pin functions used my Marvell in the
> > kirkwood reference design. It is likely that many real boards will be
> > based on that. However, if my bubba3 SPI pins don't fit with the
> > Marvell RDK, i probably want to put them in my board file.
> 
> Sorry I'm not following, what is an RDK?

Reference Design Kit. 

A chip manufacture generally has a reference board which uses most of
the functionality of the chip. They generally make the board design
available, so that anybody wanting to design a new board around the
chip can start with the RDK and add/remove parts and customize it to
there own requirements. 

Marvell are a bit closed about there RDKs, so i picked an AT91 as an
example:

http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4281&category_id=163&family_id=605&subfamily_id=1964

All the design files are there for download.

Many boards using an AT91SAM9XE will be similar to this. So if the
pinmux driver supports this board, it will be a good basis for all
other boards which use the AT91SAM9XE.

    Andrew
