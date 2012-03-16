Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031034Ab2CPUGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:06:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:13396 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964874Ab2CPUGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:06:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140118460"
Date: Fri, 16 Mar 2012 21:14:45 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Peter Korsgaard <jacmet@sunsite.dk>, Arnd Bergmann <arnd@arndb.de>,
        Rob Lee <rob.lee@linaro.org>
Subject: Re: [PATCH v10] mfd: Add anatop mfd driver
Message-ID: <20120316201445.GV20524@sortiz-mobl>
References: <1331885816-26902-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331885816-26902-1-git-send-email-paul.liu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 16, 2012 at 04:16:56PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop is a mfd chip embedded in Freescale i.MX6Q SoC.
> Anatop provides regulators and thermal.
> This driver handles the address space and the operation of the mfd device.
I applied this one, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
