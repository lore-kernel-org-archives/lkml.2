Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2IYRxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:53:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40765 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2IYRxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:53:05 -0400
Date: Tue, 25 Sep 2012 18:52:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, b-cousson@ti.com, balbi@ti.com,
        santosh.shilimkar@ti.com, sameo@linux.intel.com
Subject: Re: [PATCHv2 1/4] mfd: smsc: Add support for smsc gpio io/keypad
 driver
Message-ID: <20120925175255.GA13823@sirena.org.uk>
References: <1346844964-24839-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346844964-24839-1-git-send-email-sourav.poddar@ti.com>
X-Cookie: You will pass away very quickly.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:06:04PM +0530, Sourav Poddar wrote:

> +static struct regmap_config smsc_regmap_config = {
> +		.reg_bits = 8,
> +		.val_bits = 8,
> +		.max_register = SMSC_MAX_REGISTER - 1;
> +		.cache_type = REGCACHE_COMPRESSED,
> +};

That definition of max_register looks wrong - why are we subtracting 1
from a macro called MAX_REGISTER to get it?

Indentation here is a bit odd too.

> +static int smsc_i2c_remove(struct i2c_client *i2c)
> +{
> +	return 0;
> +}

Remove empty functions.
