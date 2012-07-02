Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab2GBK6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:58:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:10085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932754Ab2GBK6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:58:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187454088"
Date: Mon, 2 Jul 2012 13:09:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Chris Rattray <crattray@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: wm8994: Restore pin configuration after reset
 during suspend
Message-ID: <20120702110931.GA22065@sortiz-mobl>
References: <1339433017-7150-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339433017-7150-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jun 12, 2012 at 12:43:35AM +0800, Mark Brown wrote:
> From: Chris Rattray <crattray@opensource.wolfsonmicro.com>
> 
> Ensure that we leave the device with the pins in the expected
> configuration if we leave it in reset over suspend, avoiding any
> interoperation problems with other devices in the system.
> 
> Signed-off-by: Chris Rattray <crattray@opensource.wolfsonmicro.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-core.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
