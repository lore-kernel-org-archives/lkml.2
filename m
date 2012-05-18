Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967098Ab2ERJAC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:00:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:57000 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965235Ab2ERI77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:59:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101562383"
Date: Fri, 18 May 2012 11:09:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        paul.liu@linaro.org, broonie@opensource.wolfsonmicro.com,
        shawn.guo@linaro.org, Richard Zhao <richard.zhao@freescale.com>
Subject: Re: [PATCH V2] mfd: anatop: make register accessor more flexible and
 rename meaningfully
Message-ID: <20120518090954.GC12015@sortiz-mobl>
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com>
 <1336871882-6796-1-git-send-email-richard.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336871882-6796-1-git-send-email-richard.zhao@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Sun, May 13, 2012 at 09:18:02AM +0800, Richard Zhao wrote:
>  - rename to anatop_read_reg and anatop_write_reg
>  - anatop_read_reg directly return reg value
>  - anatop_write_reg write reg with mask
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
