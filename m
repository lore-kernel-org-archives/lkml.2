Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab2BWPeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 10:34:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:23596 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2BWPeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 10:34:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109948363"
Date: Thu, 23 Feb 2012 16:34:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] mfd: Make pcf50633_write_block() return 0 on success
Message-ID: <20120223153408.GE24377@sortiz-mobl>
References: <1329190231.4285.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329190231.4285.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Feb 14, 2012 at 11:30:31AM +0800, Axel Lin wrote:
> The callers of pcf50633_write_block assume pcf50633_write_block return 0 on
> success, thus make it return 0 instead of the number of registers written on
> success.
> 
> Currently pcf50633_write_block is called in drivers/mfd/pcf50633-irq.c and
> drivers/rtc/rtc-pcf50633.c.
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
