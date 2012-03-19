Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab2CSPtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:49:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57388 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab2CSPtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:49:17 -0400
Message-ID: <1332172283.22775.79.camel@saladin.home.flameeyes.eu>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
From: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Date: Mon, 19 Mar 2012 16:51:23 +0100
In-Reply-To: <20120318160718.GA26847@ericsson.com>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
	 <20120317123151.AAF9A3E0952@localhost>
	 <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
	 <20120318160718.GA26847@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno dom, 18/03/2012 alle 09.07 -0700, Guenter Roeck ha scritto:
> I don't think that would make sense. IT8761E has a completely
> different set
> of registers. It is a "Legacy Low Pin Count I/O" only. The other chips
> are
> environmental control chips. I didn't follow the context of this
> discussion,
> but IT8761E does not support a watchdog. It also only supports 16 GPIO
> pins.

Not for watchdog, but the GPIO does require just a few modifications to
support both chips as far as I can tell, I have some testable code here
I think, but I wanted to see if I could implement MFD as well.

-- 
Diego Elio Pettenò — Flameeyes
http://blog.flameeyes.eu/


