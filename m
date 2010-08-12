Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab0HLJvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:51:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:13218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab0HLJvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,357,1278313200"; 
   d="scan'208";a="826964221"
Date: Thu, 12 Aug 2010 11:51:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory Bean <gbean@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: linux-next: manual merge of the mfd tree with Linus' tree
Message-ID: <20100812095120.GA2528@sortiz-mobl>
References: <20100812144135.4834268b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812144135.4834268b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Aug 12, 2010 at 02:41:35PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> Today's linux-next merge of the mfd tree got a conflict in
> drivers/gpio/Kconfig between commit
> c34f16b70a52e348a62944fe0d5c7c1eb9ad5b72 ("gpio: sx150x: add Semtech I2C
> sx150x gpio expander driver") from Linus' tree and commit
> 59d11276842199a8ee525f1e88be7eafe8614e4c ("gpio: Add STMPE GPIO driver")
> from the mfd tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix for a while.
That should be fixed now on my for-next branch.
Thanks a lot for the report.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
