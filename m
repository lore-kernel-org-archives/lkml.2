Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1LRVRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 16:17:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:32283 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1LRVRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 16:17:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="88824264"
Date: Sun, 18 Dec 2011 22:21:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        linaro-dev@lists.linaro.org, arnd@arndb.de, eric.miao@linaro.org
Subject: Re: [PATCH 01/06] MFD: DA9052/53 MFD core module v10
Message-ID: <20111218212150.GV11800@sortiz-mobl>
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
The former is fine with me, thanks in advance.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
