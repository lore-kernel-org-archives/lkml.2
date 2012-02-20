Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2BTQz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:55:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:12324 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab2BTQz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:55:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119399505"
Date: Mon, 20 Feb 2012 18:03:06 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: Add __devinit and __devexit annotations in
 wm8994
Message-ID: <20120220170306.GF5387@sortiz-mobl>
References: <1327327172-8411-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327327172-8411-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jan 23, 2012 at 01:59:30PM +0000, Mark Brown wrote:
> The wm8994_device_init() and wm8994_device_exit() functions were not
> annotated as device init and exit functions, meaning they shouldn't
> reference __devinitdata.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This is mostly just a warning fix for the second patch and doesn't seem
> terribly critical otherwise so it should probably get merged along with
> it.
Fine with me as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
