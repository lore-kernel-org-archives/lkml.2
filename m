Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1CBOf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:35:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:7315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1CBOf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:35:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="608229184"
Date: Wed, 2 Mar 2011 15:35:24 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: peter.ujfalusi@nokia.com, tony@atomide.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] mfd: twl4030_codec: Remove unused and duplicate
 audio_mclk fields
Message-ID: <20110302143523.GN16181@sortiz-mobl>
References: <1299072246-26402-1-git-send-email-ilkka.koskinen@nokia.com>
 <1299072246-26402-3-git-send-email-ilkka.koskinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299072246-26402-3-git-send-email-ilkka.koskinen@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilkka,

On Wed, Mar 02, 2011 at 03:24:06PM +0200, Ilkka Koskinen wrote:
> audio_mclk can be queried from mfd driver. Therefore, it is not
> needed in twl4030_codec_audio_data or in twl4030_codec_vibra_data
> anymore.
> 
> Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
