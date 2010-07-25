Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab0GYVyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:54:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:45123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0GYVyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:54:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,259,1278313200"; 
   d="scan'208";a="304167494"
Date: Sun, 25 Jul 2010 23:54:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>, a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, akpm@linux-foundation.org, a.zummo@towertech.it,
        gortmaker@yahoo.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH 3/3] rtc: Add MAX8998 rtc driver
Message-ID: <20100725215451.GD2613@sortiz-mobl>
References: <1279609058-32319-1-git-send-email-jy0922.shim@samsung.com>
 <1279609058-32319-3-git-send-email-jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279609058-32319-3-git-send-email-jy0922.shim@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 03:57:38PM +0900, Joonyoung Shim wrote:
> This adds support for the RTC provided by the Maxim 8998 chip. This
> driver was tested on a GONI board by using the rtc-test application from
> the Documentation/rtc.txt.
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
