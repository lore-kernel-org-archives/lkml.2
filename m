Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab0GYVvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:51:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:30821 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab0GYVvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:51:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,259,1278313200"; 
   d="scan'208";a="538635216"
Date: Sun, 25 Jul 2010 23:51:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, akpm@linux-foundation.org, a.zummo@towertech.it,
        gortmaker@yahoo.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH 1/3] mfd: MAX8998: Use struct i2c_client to argument on
 i2c operation functions
Message-ID: <20100725215107.GB2613@sortiz-mobl>
References: <1279609058-32319-1-git-send-email-jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279609058-32319-1-git-send-email-jy0922.shim@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 03:57:36PM +0900, Joonyoung Shim wrote:
> The MAX8998 chip have regulator and rtc features. The i2c slave address
> of regulator and rtc is different, so needs each i2c client on i2c
> operation functions.
> 
> Also, this patch exports i2c operation functions instead of callback to
> make easy to read.
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
For the mfd part:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
