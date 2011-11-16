Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1KPQjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:39:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59105 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756043Ab1KPQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:39:15 -0500
Date: Wed, 16 Nov 2011 16:39:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 2/7] regmap: Make reg_config reg_defaults const
Message-ID: <20111116163908.GN29986@opensource.wolfsonmicro.com>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
 <1321457302-8724-2-git-send-email-lars@metafoo.de>
 <20111116161316.GI29986@opensource.wolfsonmicro.com>
 <4EC3E385.4060006@metafoo.de>
 <20111116162442.GL29986@opensource.wolfsonmicro.com>
 <4EC3E684.90109@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC3E684.90109@metafoo.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 05:36:20PM +0100, Lars-Peter Clausen wrote:
> On 11/16/2011 05:24 PM, Mark Brown wrote:

> > Did you actually check the sparse output?

> No, because the only place we ever look at config->reg_defaults is in
> regache_init. And now I just run sparse and as expected regmap doesn't
> trigger any warnings or errors.

  CHECK   drivers/base/regmap/regmap.c
drivers/base/regmap/regmap.c:162:27: warning: incorrect type in assignment (different modifiers)
drivers/base/regmap/regmap.c:162:27:    expected struct reg_default *reg_defaults
drivers/base/regmap/regmap.c:162:27:    got struct reg_default const *const reg_defaults
