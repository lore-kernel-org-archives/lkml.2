Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab2F2LLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:11:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:23224 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2F2LLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:11:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162203019"
Date: Fri, 29 Jun 2012 13:22:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] mfd: max77693: Remove unused iolock mutex
Message-ID: <20120629112240.GJ4846@sortiz-mobl>
References: <1337849788.1028.0.camel@phoenix>
 <1337849866.1028.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337849866.1028.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, May 24, 2012 at 04:57:46PM +0800, Axel Lin wrote:
> Now this driver is using regmap APIs, the iolock mutex is not used and can be
> removed.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/max77693.c               |    2 --
>  include/linux/mfd/max77693-private.h |    1 -
>  2 files changed, 0 insertions(+), 3 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
