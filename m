Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1G0Jw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:52:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:6798 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab1G0Jw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:52:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,275,1309762800"; 
   d="scan'208";a="34999524"
Date: Wed, 27 Jul 2011 11:53:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        parthab@india.ti.com, kishon@ti.com
Subject: Re: [PATCH] mfd: omap-usb-host: fix clock API usage on
 usbhs_disable()
Message-ID: <20110727095328.GC26275@sortiz-mobl>
References: <1311340170-28773-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311340170-28773-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava,

On Fri, Jul 22, 2011 at 06:39:30PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
> 
> usbhs_disable function was invoking clk_enable() instead of
> clk_disable(), thus only increasing the clock usage counter and
> preventing this particular clock from being ever turned off.
> Because of this, the power domain of omap4 the USB Host subsystem
> would never reach lower power states.This patch calls clk_disable()
> in usbhs_disable function
I applied this patch now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
