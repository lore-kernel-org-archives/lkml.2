Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2HAUAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:00:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32960 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165Ab2HAUAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:00:07 -0400
Date: Wed, 1 Aug 2012 21:00:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 1/2] regulator: mc13892: Simplify implementation of
 mc13892_sw_regulator_set_voltage_sel()
Message-ID: <20120801200005.GK4483@opensource.wolfsonmicro.com>
References: <1342681831.13385.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342681831.13385.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 03:10:31PM +0800, Axel Lin wrote:
> Use mc13xxx_reg_rmw rather than a mc13xxx_reg_read and a mc13xxx_reg_write calls.

Applied both, thanks.
