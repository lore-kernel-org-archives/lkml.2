Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206Ab2LIP1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:27:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:47278 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758628Ab2LIP1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:27:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,246,1355126400"; 
   d="scan'208";a="259596733"
Date: Sun, 9 Dec 2012 16:27:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5102: Add readback of DSP status 3 register
Message-ID: <20121209152721.GE26699@sortiz-mobl>
References: <1354382096-26277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354382096-26277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Dec 02, 2012 at 02:14:56AM +0900, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c           |    2 ++
>  include/linux/mfd/arizona/registers.h |    1 +
>  2 files changed, 3 insertions(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
