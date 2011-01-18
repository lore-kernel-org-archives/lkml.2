Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1ARLGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 06:06:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46366 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1ARLGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 06:06:15 -0500
Date: Tue, 18 Jan 2011 12:06:10 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH] pxa3xx: fix PXA GPIO IRQ handling
Message-ID: <20110118110610.GX6917@pengutronix.de>
References: <1295338561.2003.3.camel@sven>
 <1295338738-4129-1-git-send-email-s.neumann@raumfeld.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295338738-4129-1-git-send-email-s.neumann@raumfeld.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 09:18:58AM +0100, Sven Neumann wrote:
> From: Lars-Peter Clausen <lars@metafoo.de>
> 
> Set the "set_wake" field of the irq_chip struct before calling
> set_irq_chip() for all of the IRQs, so that the compat handler
> actually gets installed.
> 
> Tested-by: Sven Neumann <s.neumann@raumfeld.com>
If you send the patch out it needs your S-o-b, too.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
