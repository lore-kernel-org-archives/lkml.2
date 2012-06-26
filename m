Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab2FZImf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:42:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:13479 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab2FZIme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:42:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="158275705"
Date: Tue, 26 Jun 2012 10:53:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH] mfd: MFD_MAX77686 needs to select REGMAP_I2C and
 IRQ_DOMAIN
Message-ID: <20120626085332.GB4846@sortiz-mobl>
References: <1340674008.2942.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340674008.2942.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Jun 26, 2012 at 09:26:48AM +0800, Axel Lin wrote:
> Select REGMAP_I2C to fix below build errors:
> 
>   CC      drivers/mfd/max77686.o
> drivers/mfd/max77686.c:43:15: error: variable 'max77686_regmap_config' has initializer but incomplete type
> drivers/mfd/max77686.c:44:2: error: unknown field 'reg_bits' specified in initializer
> drivers/mfd/max77686.c:44:2: warning: excess elements in struct initializer [enabled by default]
> drivers/mfd/max77686.c:44:2: warning: (near initialization for 'max77686_regmap_config') [enabled by default]
> drivers/mfd/max77686.c:45:2: error: unknown field 'val_bits' specified in initializer
> drivers/mfd/max77686.c:45:2: warning: excess elements in struct initializer [enabled by default]
> drivers/mfd/max77686.c:45:2: warning: (near initialization for 'max77686_regmap_config') [enabled by default]
> drivers/mfd/max77686.c: In function 'max77686_i2c_probe':
> drivers/mfd/max77686.c:60:2: error: implicit declaration of function 'regmap_init_i2c' [-Werror=implicit-function-declaration]
> drivers/mfd/max77686.c:60:19: warning: assignment makes pointer from integer without a cast [enabled by default]
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/mfd/max77686.o] Error 1
> make[1]: *** [drivers/mfd] Error 2
> make: *** [drivers] Error 2
> 
> Select IRQ_DOMAIN to fix below build errors:
I squashed this one with the initial commit, thanks a lot for the patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
