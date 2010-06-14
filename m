Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab0FNMNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:13:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56117 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751700Ab0FNMNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:13:51 -0400
Date: Mon, 14 Jun 2010 13:13:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 V2] gpio: add STMPE811 gpio controller support
Message-ID: <20100614121349.GC14604@rakim.wolfsonmicro.main>
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
 <1276511558-27121-3-git-send-email-l.fu@pengutronix.de>
 <20100614115123.GB14604@rakim.wolfsonmicro.main>
 <20100614120943.GB12027@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614120943.GB12027@pengutronix.de>
X-Cookie: I brake for chezlogs!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 02:09:43PM +0200, Luotao Fu wrote:
> On Mon, Jun 14, 2010 at 12:51:23PM +0100, Mark Brown wrote:

> > Assuming you're able to do interrupts on the GPIOs you should now be
> > able to implement to_irq() as well.

> The chip can indeed generate irqs on the GPIO line. I, however, kept out
> the irq stuff for now because i want to get the core functionalies done
> for this turn. I'd like to add the irq stuff with a separate patch later.

It should be a trivial function - it just does a mapping from a GPIO
number to an IRQ number.
