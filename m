Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1GKLnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:43:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34450 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754637Ab1GKLnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:43:18 -0400
Date: Mon, 11 Jul 2011 20:43:06 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant@secretlab.ca>, patches@opensource.wolfsonmicro.com,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/6] clk: Initial feedback for off-SoC slow bus clocks
Message-ID: <20110711114304.GJ5092@opensource.wolfsonmicro.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <20110711093124.GA3239@n2100.arm.linux.org.uk>
 <20110711100759.GG26347@pengutronix.de>
 <20110711102856.GG3239@n2100.arm.linux.org.uk>
 <20110711104625.GH26347@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711104625.GH26347@pengutronix.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:46:25PM +0200, Sascha Hauer wrote:
> On Mon, Jul 11, 2011 at 11:28:56AM +0100, Russell King - ARM Linux wrote:

> > If that's all its for, then can't some other solution for debugfs names
> > (lets stop calling them clock names to avoid confusion) be found -
> > such as

> > 	sprintf(debugfsname, "%s@%p", clk->debugfsprefix, clk);

> Sounds good. During my tests on i.MX I found it very convenient to have
> speaking debugfs names, so I vote for this suggestion instead the
> following ones.

FWIW that's pretty much exactly what I added except I used a - instead
of @.
