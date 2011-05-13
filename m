Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1EMOOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:14:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:31618 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab1EMOOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:14:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,364,1301900400"; 
   d="scan'208";a="642294453"
Date: Fri, 13 May 2011 16:14:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        a.zummo@towertech.it, khali@linux-fr.org, ben-linux@fluff.org
Subject: Re: [PATCH 2/6] mfd: 88pm860x: avoid to allocate static platform
 data
Message-ID: <20110513141433.GB8970@sortiz-mobl>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Fri, May 06, 2011 at 05:21:21PM +0800, Haojian Zhuang wrote:
> Maybe multiple PMIC devices are installed into one board. Static variable
> can only make driver logic mess. So remove these variable, and use
> platform data from platform driver instead.
Very good, thanks a lot.
Applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
