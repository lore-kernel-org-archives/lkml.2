Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1KNA1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:27:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:42240 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab1KNA1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:27:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,503,1315206000"; 
   d="scan'208";a="74337473"
Date: Mon, 14 Nov 2011 01:32:03 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mfd: add #ifdef CONFIG_DEBUG_FS guard for
 ab8500_debug_resources
Message-ID: <20111114003203.GK22218@sortiz-mobl>
References: <1320890178.13074.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320890178.13074.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Nov 10, 2011 at 09:56:18AM +0800, Axel Lin wrote:
> Fix below build warning if CONFIG_DEBUG_FS is disabled.
> 
>   CC      drivers/mfd/ab8500-core.o
> drivers/mfd/ab8500-core.c:623: warning: 'ab8500_debug_resources' defined but not used
> 
Thanks for the fix, I applied this one to my for-linus branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
