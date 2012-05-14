Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2ENUNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:13:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:37466 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab2ENUNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:13:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166180851"
Date: Mon, 14 May 2012 22:22:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20120514202258.GC12740@sortiz-mobl>
References: <20120514133753.77567dfa46a1e51f9d33bb47@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120514133753.77567dfa46a1e51f9d33bb47@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, May 14, 2012 at 01:37:53PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> ERROR: "wm8400_block_read" [drivers/regulator/wm8400-regulator.ko] undefined!
> ERROR: "regmap_reinit_cache" [drivers/mfd/wm8400-core.ko] undefined!
> 
> Caused by commit 4d240045599c ("mfd: Remove wm8400 custom cache
> implementation").
> 
> I have used the mfd tree from next-20120511 for today.
This should be fixed now, thanks to Mark patches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
