Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab1EMOYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:24:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:48298 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803Ab1EMOYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:24:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,364,1301900400"; 
   d="scan'208";a="642298879"
Date: Fri, 13 May 2011 16:24:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        a.zummo@towertech.it, khali@linux-fr.org, ben-linux@fluff.org
Subject: Re: [PATCH 5/6] mfd: 88pm860x: remove unused parameter
Message-ID: <20110513142408.GE8970@sortiz-mobl>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-5-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304673685-21324-5-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Fri, May 06, 2011 at 05:21:24PM +0800, Haojian Zhuang wrote:
> i2c_client parameter isn't used in some functions. Just remove it.
Patch applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
