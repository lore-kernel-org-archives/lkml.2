Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2EXHDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:03:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:34903 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2EXHDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:03:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103667547"
Date: Thu, 24 May 2012 09:03:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix build break of max77693 by adding REGMAP_I2C
 option
Message-ID: <20120524070315.GA5401@sortiz-mobl>
References: <1337839738-18246-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337839738-18246-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Thu, May 24, 2012 at 03:08:58PM +0900, Chanwoo Choi wrote:
> This patch add REGMAP_I2C config option to fix build break
> of max77693 mfd driver because max77693 use regmap interface
> for i2c communication.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
