Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab1EMOV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:21:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:64730 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab1EMOV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:21:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,364,1301900400"; 
   d="scan'208";a="435620324"
Date: Fri, 13 May 2011 16:21:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        a.zummo@towertech.it, khali@linux-fr.org, ben-linux@fluff.org,
        Samuel Ortiz <samuel.ortiz@intel.com>
Subject: Re: [PATCH 4/6] mfd: 88pm860x: avoid to use constraint name in
 regulator driver
Message-ID: <20110513142132.GD8970@sortiz-mobl>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Fri, May 06, 2011 at 05:21:23PM +0800, Haojian Zhuang wrote:
> Avoid to use constraint name in regulator driver. So use regulator id is used
> instead in platform driver.
Patch applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
