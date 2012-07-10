Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2GJJJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:09:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:55695 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab2GJJJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120665725"
Date: Tue, 10 Jul 2012 11:20:44 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20120710092044.GX15345@sortiz-mobl>
References: <20120709135719.5c8b0f033520f5981efb2c93@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709135719.5c8b0f033520f5981efb2c93@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Jul 09, 2012 at 01:57:19PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> ERROR: "arizona_dai_ops" [sound/soc/codecs/snd-soc-wm5102.ko] undefined!
> ERROR: "wm5102_aod" [drivers/mfd/arizona-irq.ko] undefined!
> ERROR: "wm5102_irq" [drivers/mfd/arizona-irq.ko] undefined!
> ERROR: "irq_set_chip_and_handler_name" [drivers/mfd/arizona-irq.ko] undefined!
> ERROR: "wm5102_patch" [drivers/mfd/arizona-core.ko] undefined!
> ERROR: "arizona_irq_init" [drivers/mfd/arizona-core.ko] undefined!
> ERROR: "arizona_irq_exit" [drivers/mfd/arizona-core.ko] undefined!
> 
> I have used the mfd tree from next-20120706 for today.
The mfd and sound trees are now fixed and you should no longer get those
failures.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
