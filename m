Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004Ab1ETEG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:06:57 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41678 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1ETEG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:06:56 -0400
Date: Thu, 19 May 2011 23:54:12 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Kyungmin Park <kmpark@infradead.org>
cc: Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
In-Reply-To: <BANLkTikonewi-fxCxoxx=ARsTs-CPvfoTg@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1105192351360.14430@xanadu.home>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com> <20110519085638.GA26816@S2100-06.ap.freescale.net> <BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com> <20110519135631.GB26816@S2100-06.ap.freescale.net> <20110519191156.GE2429@pengutronix.de>
 <alpine.LFD.2.00.1105191527440.14430@xanadu.home> <20110520031818.GB27251@S2100-06.ap.freescale.net> <BANLkTikonewi-fxCxoxx=ARsTs-CPvfoTg@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, Kyungmin Park wrote:

> BTW, how do you think the GPIO interrupt routine. If it uses the
> drivers/gpio drivers, it also cover the gpio interrupt codes at
> drivers/gpio? or separate it?

Let's just do the move for now.  I don't think it is worth splitting out 
the IRQ code just yet, unless there is a common pattern to be seen 
there.


Nicolas
