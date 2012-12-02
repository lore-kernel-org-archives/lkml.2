Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2LBXlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 18:41:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:43033 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab2LBXlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 18:41:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,202,1355126400"; 
   d="scan'208";a="257986071"
Date: Mon, 3 Dec 2012 00:41:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: arizona: Defer patch initialistation until
 after first device boot
Message-ID: <20121202234113.GX3176@sortiz-mobl>
References: <1354416107-17481-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354416107-17481-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Dec 02, 2012 at 11:41:46AM +0900, Mark Brown wrote:
> Make sure that we don't race with the initial device boot by only doing
> the initialisation after we've waited for the boot to complete.
> 
> The runtime PM code already waits for the boot to complete before it
> syncs the register patches so in most systems if a race does occur we will
> power down very soon afterwards and recover anyway.
> 
> Reported-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
