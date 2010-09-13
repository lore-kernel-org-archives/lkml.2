Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0IMN6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:58:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:57085 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab0IMN6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:58:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,359,1280732400"; 
   d="scan'208";a="323942468"
Date: Mon, 13 Sep 2010 15:59:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Hannemann <arnd@arndnet.de>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: manual merge of the mfd tree with Linus' tree
Message-ID: <20100913135915.GI2555@sortiz-mobl>
References: <20100913115404.cfbe7182.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913115404.cfbe7182.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Sep 13, 2010 at 11:54:04AM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> Today's linux-next merge of the mfd tree got a conflict in
> arch/arm/mach-shmobile/board-ap4evb.c between commit
> 410d878bd05315a19894b8b4685107f2cd0712a5 ("ARM: mach-shmobile: ap4evb:
> fix write protect for SDHI1") from Linus' tree and commit
> c3cfb4003377a3397b27de0efe910c9abd838ac3 ("ARM: mach-shmobile: ap4evb:
> Fix hotplug for SDHI1") from the mfd tree.
The conflict should be merged by now. Thanks for the warning.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
