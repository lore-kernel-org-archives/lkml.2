Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1AKLXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:23:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:40744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab1AKLXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:23:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,306,1291622400"; 
   d="scan'208";a="645648369"
Date: Tue, 11 Jan 2011 12:22:59 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v4 2/3] regulator MAX8998/LP3974: Support DVS-GPIO.
Message-ID: <20110111112258.GE6616@sortiz-mobl>
References: <20101224113805.GI27832@sortiz-mobl>
 <1294118261-18906-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294118261-18906-3-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Myungjoo,

On Tue, Jan 04, 2011 at 02:17:40PM +0900, MyungJoo Ham wrote:
> The previous driver did not support BUCK1-DVS3, BUCK1-DVS4, and
> BUCK2-DVS2 modes. This patch adds such modes and an option to block
> setting buck1/2 voltages out of the preset values.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
I applied this patch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
