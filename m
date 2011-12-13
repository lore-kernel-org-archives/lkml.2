Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1LMUhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:37:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:8316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab1LMUhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:37:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86191064"
Date: Tue, 13 Dec 2011 21:42:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        linaro-dev@lists.linaro.org, arnd@arndb.de, eric.miao@linaro.org
Subject: Re: [PATCH 01/06] MFD: DA9052/53 MFD core module v10
Message-ID: <20111213204250.GE2796@sortiz-mobl>
References: <1323700616.1626.7.camel@dhruva>
 <20111213063344.GC7148@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213063344.GC7148@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Dec 13, 2011 at 02:33:45PM +0800, Mark Brown wrote:
> On Mon, Dec 12, 2011 at 08:06:56PM +0530, Ashish Jangam wrote:
> > The DA9052/53 is a highly integrated PMIC subsystem with supply domain
> > flexibility to support wide range of high performance application.
> 
> > It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> > control and other functionality.
> 
> > This patch is functionally tested on Samsung SMDKV6410.
> 
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Looking good now!  Samuel, this uses regmap-irq so either I can carry
> this or you can merge:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git topic/irq
> 
> into your tree to get the changes that the driver depends on.
It's probably easier for you to merge it. Please add my
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
