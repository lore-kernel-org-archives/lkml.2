Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2KZLRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:17:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:31863 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab2KZLRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:17:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,319,1352102400"; 
   d="scan'208";a="222353415"
Date: Mon, 26 Nov 2012 12:16:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org
Subject: Re: [PATCH V1 1/3] mfd: stmpe: Arrange #include <header files> in
 alphabetical order
Message-ID: <20121126111639.GR12685@sortiz-mobl>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Fri, Nov 23, 2012 at 12:26:18AM +0530, Viresh Kumar wrote:
> This helps managing them better and also reduces chances of adding an header
> file twice.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/mfd/stmpe-spi.c | 2 +-
>  drivers/mfd/stmpe.c     | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
I fail to see the point of this patch, sorry.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
