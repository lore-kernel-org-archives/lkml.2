Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2F2NNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:13:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:5168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638Ab2F2NNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:13:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159704683"
Date: Fri, 29 Jun 2012 15:24:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/22] mfd: Remove redundant Kconfig entry
Message-ID: <20120629132419.GM4846@sortiz-mobl>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-19-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338353260-10097-19-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed, May 30, 2012 at 12:47:36PM +0800, Lee Jones wrote:
> During ab8500-core clean-up the Kconfig entry for AB8500_I2C_CORE
> was left remnant. This patch simply removes it.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/Kconfig |   10 ----------
>  1 file changed, 10 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
