Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab1IOQt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 12:49:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:41678 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192Ab1IOQt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 12:49:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,388,1312182000"; 
   d="scan'208";a="49229671"
Date: Thu, 15 Sep 2011 18:52:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Thomas Weber <weber@corscience.de>
Cc: linux-kernel@vger.kernel.org, peter.ujfalusi@ti.com,
        linux-omap@vger.kernel.org, broonie@opensource.wolfsonicro.com,
        tiwai@suse.de, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC/MFD: twl4030: Fix dependencies for audio codec
Message-ID: <20110915165206.GH32263@sortiz-mobl>
References: <1315214793-661-1-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315214793-661-1-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi THomas,

On Mon, Sep 05, 2011 at 11:26:33AM +0200, Thomas Weber wrote:
> The codec for Devkit8000 (TWL4030)  was not detected except
> when build with CONFIG_SND_SOC_ALL_CODECS.
> 
> twl-core.c still uses the CONFIG_TWL4030_CODEC for
> twl_has_codec().
> 
> In commit 57fe7251f5bfc4332f24479376de48a1e8ca6211
> the CONFIG_TWL4030_CODEC was renamed
> into CONFIG_MFD_TWL4030_AUDIO, thatswhy the codec
> was not detected.
> 
> This patch renames the CONFIG_ TWL4030_CODEC into
> CONFIG_MFD_TWL4030_AUDIO in twl-core.c.
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>
Applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
