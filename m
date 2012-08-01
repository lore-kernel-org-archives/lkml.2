Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2HAT4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:56:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32910 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155Ab2HAT4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:56:52 -0400
Date: Wed, 1 Aug 2012 20:56:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] regulator: mc13xxx: Populate selector from
 mc13xxx_fixed_regulator_set_voltage
Message-ID: <20120801195650.GF4483@opensource.wolfsonmicro.com>
References: <1342191674.10881.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342191674.10881.2.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:01:14PM +0800, Axel Lin wrote:
> This was missing until now and the underlying
> _regulator_do_set_voltage is using this value when calling list_voltage.

Applied, thanks.
