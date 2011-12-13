Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1LMGeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:34:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53857 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab1LMGd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:33:57 -0500
Date: Tue, 13 Dec 2011 14:33:45 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        linaro-dev@lists.linaro.org, arnd@arndb.de, eric.miao@linaro.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 01/06] MFD: DA9052/53 MFD core module v10
Message-ID: <20111213063344.GC7148@opensource.wolfsonmicro.com>
References: <1323700616.1626.7.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323700616.1626.7.camel@dhruva>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 08:06:56PM +0530, Ashish Jangam wrote:
> The DA9052/53 is a highly integrated PMIC subsystem with supply domain
> flexibility to support wide range of high performance application.

> It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> control and other functionality.

> This patch is functionally tested on Samsung SMDKV6410.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Looking good now!  Samuel, this uses regmap-irq so either I can carry
this or you can merge:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git topic/irq

into your tree to get the changes that the driver depends on.
