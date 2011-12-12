Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab1LLFBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:01:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43153 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab1LLFBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:01:17 -0500
Date: Mon, 12 Dec 2011 13:01:13 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        arnd@arndb.de, linaro-dev@lists.linaro.org, eric.miao@linaro.org
Subject: Re: [PATCH 03/06] MFD: DA9052/53 MFD core module v9 Added SPI support
Message-ID: <20111212050111.GC3216@opensource.wolfsonmicro.com>
References: <1323440193.23171.71.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323440193.23171.71.camel@dhruva>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 07:46:33PM +0530, Ashish Jangam wrote:
> The DA9052/53 is a highly integrated PMIC subsystem with supply domain
> flexibility to support wide range of high performance application.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Looks good, though again you should've CCed Samuel.  One small thing:

>  
>  	struct device *dev;
> +	struct spi_device *spi_dev;
>  	struct i2c_client *i2c_client;

You con't actually use this (or the i2c_client) any more so could just
drop them.
