Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1CQXlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:41:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:12587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab1CQXli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:41:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="614399460"
Date: Fri, 18 Mar 2011 00:41:23 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 1/3] mfd: add a core driver for TI TPS61050/TPS61052
 chips v2
Message-ID: <20110317234122.GD32172@sortiz-mobl>
References: <1299672158-4711-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299672158-4711-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Mar 09, 2011 at 01:02:38PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The TPS61050/TPS61052 are boost converters, LED drivers, LED flash
> drivers and a simple GPIO pin chips.
Patch applied, with this minor fix:

> +fail:
> +	i2c_set_clientdata(client, NULL);
You don't need to set that as this is handled by the i2c core.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
