Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1DRI62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:58:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:28850 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab1DRI6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:58:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,231,1301900400"; 
   d="scan'208";a="680498887"
Date: Mon, 18 Apr 2011 10:58:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mfd: asic3: Fix build error
Message-ID: <20110418085819.GC8593@sortiz-mobl>
References: <1302792227.8637.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302792227.8637.2.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Apr 14, 2011 at 10:43:47PM +0800, Axel Lin wrote:
> Fix below compile error:
> 
>   CC      drivers/mfd/asic3.o
> drivers/mfd/asic3.c: In function 'asic3_irq_demux':
> drivers/mfd/asic3.c:147: error: 'irq_data' undeclared (first use in this function)
> drivers/mfd/asic3.c:147: error: (Each undeclared identifier is reported only once
> drivers/mfd/asic3.c:147: error: for each function it appears in.)
I wonder how this one got through...
I applied it to my for-linus branch anyway. Thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
