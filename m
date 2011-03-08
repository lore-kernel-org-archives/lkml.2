Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1CHLrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:47:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60686 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754338Ab1CHLre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:47:34 -0500
Date: Tue, 8 Mar 2011 11:47:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 3/3] mach-ux500: configure board for the TPS61052
 regulator
Message-ID: <20110308114731.GA20944@opensource.wolfsonmicro.com>
References: <1299577444-31480-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299577444-31480-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 10:44:04AM +0100, Linus Walleij wrote:

> +struct regulator_init_data tps61052_regulator = {
> +	.constraints = {
> +		.name = "vaudio-hf",
> +		.min_uV = 4500000,
> +		.max_uV = 4500000,
> +		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
> +		REGULATOR_CHANGE_STATUS,

You've got _CHANGE_VOLTAGE here but only one voltage is possible.
