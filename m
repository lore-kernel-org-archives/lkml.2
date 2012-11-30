Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab2K3K5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:57:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:42511 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2K3K5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:57:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255493942"
Date: Fri, 30 Nov 2012 11:57:31 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: grant.likely@secretlab.ca, rabin.vincent@stericsson.com,
        shiraz.hashim@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        lee.jones@linaro.org, linus.walleij@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
Message-ID: <20121130105731.GN3176@sortiz-mobl>
References: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org>
 <121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh, Lee,

On Thu, Nov 29, 2012 at 08:10:18PM +0530, Viresh Kumar wrote:
> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
> 
> This patch extends existing DT support for stmpe devices. This updates:
> - DT support from stmpe SPI and I2C drivers
> - missing header files in stmpe.c
> - stmpe_of_probe() with pwm, rotator and new bindings.
> - Bindings are updated in binding document.
> 
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V4->V5:
> ------
> - 2/3 and 3/3 merged.
> - irq_trigger is kept same for non-DT booti.
> 
> @Lee: I haven't added your Acked-by, because this differs from your Acked
> version.
Lee, are you ok with this one ? Could you give it a test ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
