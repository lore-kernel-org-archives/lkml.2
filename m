Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab2I1XUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:20:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:10091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758713Ab2I1XUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:20:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,504,1344236400"; 
   d="scan'208";a="150468074"
Date: Sat, 29 Sep 2012 01:20:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        David Dajun Chen <dchen@diasemi.com>
Subject: Re: [Patch v1 1/7] DA9055 MFD core driver
Message-ID: <20120928232028.GS30928@sortiz-mobl>
References: <1347629090.18587.9.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347629090.18587.9.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jangam,

On Fri, Sep 14, 2012 at 06:54:50PM +0530, Ashish Jangam wrote:
> This is the DA9055 MFD core driver that instantiate all the dependent
> component
> drivers and provides them the device access via I2C.
> 
> This patch is functionally tested on Samsung SMDK6410.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
>  drivers/mfd/Kconfig              |   17 +
>  drivers/mfd/Makefile             |    3 +
>  drivers/mfd/da9055-core.c        |  423 +++++++++++++++++++++++
>  drivers/mfd/da9055-i2c.c         |   93 +++++
>  include/linux/mfd/da9055/core.h  |   94 +++++
>  include/linux/mfd/da9055/pdata.h |   32 ++
>  include/linux/mfd/da9055/reg.h   |  699 ++++++++++++++++++++++++++++++++++++++
>  7 files changed, 1361 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/da9055-core.c
>  create mode 100644 drivers/mfd/da9055-i2c.c
>  create mode 100644 include/linux/mfd/da9055/core.h
>  create mode 100644 include/linux/mfd/da9055/pdata.h
>  create mode 100644 include/linux/mfd/da9055/reg.h
Looks good to me, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
