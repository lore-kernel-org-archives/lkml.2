Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2GPNB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:01:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:11684 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab2GPNBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:01:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177994482"
Date: Mon, 16 Jul 2012 15:01:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: wm5110: Add data tables for the WM5110
Message-ID: <20120716130159.GD20652@sortiz-mobl>
References: <1341920279-7760-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341920279-7760-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jul 10, 2012 at 12:37:57PM +0100, Mark Brown wrote:
> The WM5110 is a highly integrated low power audio subsystem for
> smartphones, tablets and other portable audio devices. It combines
> an advanced DSP feature set with a flexible, high performance audio
> hub CODEC.
> 
> This patch adds data tables for the WM5110.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5110-tables.c | 2281 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 2281 insertions(+)
>  create mode 100644 drivers/mfd/wm5110-tables.c
The 2 wm5110 patches are applied now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
