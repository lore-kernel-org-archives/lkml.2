Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0FNJfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:35:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60290 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab0FNJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:35:08 -0400
Date: Mon, 14 Jun 2010 11:34:59 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100614093459.GD12159@pengutronix.de>
References: <201006111557.12249.jeremy.kerr@canonical.com> <19473.61547.684572.647641@ipc1.ka-ro> <201006111718.47426.jeremy.kerr@canonical.com> <19474.172.742782.972629@ipc1.ka-ro> <20100611095839.GC10894@pengutronix.de> <19474.2817.333749.485028@ipc1.ka-ro> <1276319643.1962.181.camel@pasglop> <19477.52889.982995.407051@ipc1.ka-ro> <20100614064028.GA12159@pengutronix.de> <19477.53673.644128.558827@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19477.53673.644128.558827@ipc1.ka-ro>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> And arch/arm/plat-s3c/clock.c has the following comment:
> |/* We originally used an mutex here, but some contexts (see resume)
> | * are calling functions such as clk_set_parent() with IRQs disabled
> | * causing an BUG to be triggered.
> | */
> |DEFINE_SPINLOCK(clocks_lock);
I wonder why it's needed to reparent clocks during resume.  And where
exactly IRQs are disabled.  Hmm, this comment was initially introduced
by v2.6.28-rc7-180-gc3391e3, its commit log talks about cpufreq, not
resume.

Ben (Dooks): Is this still relevant?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
