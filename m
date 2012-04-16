Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2DPSEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:04:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:35416 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab2DPSEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89656400"
Date: Mon, 16 Apr 2012 20:13:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH v4] mfd: da9052: add device-tree support for i2c driver
Message-ID: <20120416181311.GW24130@sortiz-mobl>
References: <1334505710-8919-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334505710-8919-1-git-send-email-paul.liu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, Apr 16, 2012 at 12:01:50AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> This patch adds device-tree support for dialog MFD and the binding
> documentations.
> 
> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
>  .../devicetree/bindings/mfd/da9052-i2c.txt         |   60 ++++++++++++++++++++
>  drivers/mfd/da9052-i2c.c                           |   50 +++++++++++++---
>  2 files changed, 102 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/da9052-i2c.txt
Patch applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
