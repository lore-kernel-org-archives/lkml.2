Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2F2Ogj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:36:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:17331 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab2F2Ogi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:36:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186626071"
Date: Fri, 29 Jun 2012 16:47:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Subject: Re: [PATCH 05/14] mfd: Enable DT probing of the DB8500 PRCMU
Message-ID: <20120629144746.GA22806@sortiz-mobl>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339428307-3850-6-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Jun 11, 2012 at 04:24:58PM +0100, Lee Jones wrote:
> This patch adds the correct compatible string for use during Device Tree
> population. Without it the DB8500 PRCMU will not be probed.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |    5 +++++
>  1 file changed, 5 insertions(+)
Patch applied now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
