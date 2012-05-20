Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2ETPSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 11:18:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:63701 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2ETPSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 11:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102122776"
Date: Sun, 20 May 2012 17:28:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps65910: fixed build error
Message-ID: <20120520152817.GY12015@sortiz-mobl>
References: <1337342245-23154-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337342245-23154-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Fri, May 18, 2012 at 05:27:25PM +0530, Laxman Dewangan wrote:
> Some of the api calls are not changed and it leads
> to following build error:
> /regulator/tps65910-regulator.c: In function 'tps65910_enable':
> /regulator/tps65910-regulator.c:491:2: error: implicit declaration of
> function 'tps65910_set_bits'
> /regulator/tps65910-regulator.c: In function 'tps65910_disable':
> /regulator/tps65910-regulator.c:504:2: error: implicit declaration of
> function 'tps65910_clear_bits'
> /regulator/tps65910-regulator.c: In function 'tps65910_get_voltage':
> /regulator/tps65910-regulator.c:628:2: warning: passing argument 1 of
> 'tps65910_reg_read' from incompatible pointer type]
> /linux/mfd/tps65910.h:856:19: note: expected 'struct tps65910 *' but
> argument is of type 'struct tps65910_reg *'
> /regulator/tps65910-regulator.c:628:2: error: too few arguments to
> function 'tps65910_reg_read'
> 
> cc1: some warnings being treated as errors
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> This patch fixes the compilation error in Samuel's tree and should go
> through Samuel's for-next.
Thanks, I squashed this one into the initial patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
