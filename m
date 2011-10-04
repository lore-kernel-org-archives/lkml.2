Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1JDKQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:16:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:3640 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab1JDKQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:16:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="59680185"
Date: Tue, 4 Oct 2011 12:19:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: Add WM1811 support
Message-ID: <20111004101902.GV4118@sortiz-mobl>
References: <1317149407-27635-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317149407-27635-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Sep 27, 2011 at 07:50:05PM +0100, Mark Brown wrote:
> The WM1811 is mostly register compatible with the WM8994 and WM8958,
> providing a high performance audio hub CODEC in a small form factor
> suitable for ultra compact system designs.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Due to the ASoC cross dependencies it seems like it'll be easier to
> merge this via ASoC - Samuel, does this make sense to you?
It does.
Liam, please add my:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to this one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
