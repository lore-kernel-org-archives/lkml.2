Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab2IQN2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:28:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:31007 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2IQN2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:28:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,435,1344236400"; 
   d="scan'208";a="193621727"
Date: Mon, 17 Sep 2012 15:28:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 tree related)
Message-ID: <20120917132836.GS3647@sortiz-mobl>
References: <20120917213833.2b3ac86e097d131065a0541d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917213833.2b3ac86e097d131065a0541d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Sep 17, 2012 at 09:38:33PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/mfd/max8907.c: In function 'max8907_i2c_probe':
> drivers/mfd/max8907.c:248:10: error: too few arguments to function 'mfd_add_devices'
> include/linux/mfd/core.h:100:12: note: declared here
> 
> Caused by commit 6c2591532a6f ("mfd: Add MAX8907 core driver") from the
> mfd tree interacting with commit 0848c94fb4a5 ("mfd: core: Push irqdomain
> mapping out into devices") from Linus' tree.
My bad. And Stephen even warned me about it...
It should be all fixed now, sorry about that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
