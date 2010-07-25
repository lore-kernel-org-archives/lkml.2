Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab0GYVxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:53:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:19567 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab0GYVxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:53:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,259,1278313200"; 
   d="scan'208";a="821471615"
Date: Sun, 25 Jul 2010 23:52:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        akpm@linux-foundation.org, a.zummo@towertech.it, gortmaker@yahoo.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com
Subject: Re: [PATCH 2/3] mfd: MAX8998: Add interrupts support
Message-ID: <20100725215252.GC2613@sortiz-mobl>
References: <1279609058-32319-1-git-send-email-jy0922.shim@samsung.com>
 <1279609058-32319-2-git-send-email-jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279609058-32319-2-git-send-email-jy0922.shim@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 03:57:37PM +0900, Joonyoung Shim wrote:
> Use genirq and provide seperated file for interrupts support.
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
