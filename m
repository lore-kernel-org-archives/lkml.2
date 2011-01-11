Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1AKLWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:22:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:24146 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab1AKLWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:22:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,306,1291622400"; 
   d="scan'208";a="645648141"
Date: Tue, 11 Jan 2011 12:22:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v4 1/3] MFD MAX8998/LP3974: Support LP3974 RTC
Message-ID: <20110111112207.GD6616@sortiz-mobl>
References: <20101224113805.GI27832@sortiz-mobl>
 <1294118261-18906-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294118261-18906-2-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

On Tue, Jan 04, 2011 at 02:17:39PM +0900, MyungJoo Ham wrote:
> The first releases of LP3974 have a large delay in RTC registers,
> which requires 2 seconds of delay after writing to a rtc register
> (recommended by National Semiconductor's engineers)
> before reading it.
> 
> If "rtc_delay" field of the platform data is true, the rtc driver
> assumes that such delays are required. Although we have not seen
> LP3974s without requiring such delays, we assume that such LP3974s
> will be released soon (or they have done so already) and they are
> supported by "lp3974" without setting "rtc_delay" at the platform
> data.
> 
> This patch adds delays with msleep when writing values to RTC registers
> if the platform data has rtc_delay set.
Patch applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
