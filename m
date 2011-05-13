Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1EMOVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:21:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:24336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318Ab1EMOVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:21:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,364,1301900400"; 
   d="scan'208";a="1822123"
Date: Fri, 13 May 2011 16:20:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        a.zummo@towertech.it, khali@linux-fr.org, ben-linux@fluff.org
Subject: Re: [PATCH 3/6] mfd: 88pm860x: enhance lock on i2c transaction
Message-ID: <20110513142057.GC8970@sortiz-mobl>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Fri, May 06, 2011 at 05:21:22PM +0800, Haojian Zhuang wrote:
> Accessing test page in 88pm860x is a sequence of read/write on i2c bus.
> Bus lock is used in each small i2c transaction. But it may result the
> whole sequence interrupted by other i2c client transaction.
Sure, but what you mainly want is your MFD i2c IO calls to be serialized, and
that's already being taken care of by the current code.
Are other i2c clients (non MFD ones) touching the same i2c registers than the
MFD ones ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
