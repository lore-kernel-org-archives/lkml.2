Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab2ERI32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:29:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:40059 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab2ERI3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:29:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101556045"
Date: Fri, 18 May 2012 10:39:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20120518083919.GB12015@sortiz-mobl>
References: <20120516160906.25825987b7cd731a4b5215e1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516160906.25825987b7cd731a4b5215e1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, May 16, 2012 at 04:09:06PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/built-in.o: In function `wm8400_i2c_probe':
> wm8400-core.c:(.text+0x100165): undefined reference to `devm_regmap_init_i2c'
> drivers/built-in.o: In function `wm8400_module_init':
> wm8400-core.c:(.init.text+0xb43c): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `wm8400_module_exit':
> wm8400-core.c:(.exit.text+0x655): undefined reference to `i2c_del_driver'
> 
> Probably caused by commit 96cd102ae039 ("mfd: Don't support non-modular
> wm8400 build") which was introduced to fix other problems.  In this
> build, CONFIG_I2C=m and CONFIG_REGMAP_I2C=m.
> 
> I have used the mfd tree from next-20120511 again for today.
Sorry for the delay, this should be fixed now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
