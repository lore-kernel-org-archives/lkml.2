Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab1IOQxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 12:53:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:49936 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab1IOQxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 12:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48813967"
Date: Thu, 15 Sep 2011 18:55:50 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Support software initiated shutdown of WM831x PMICs
Message-ID: <20110915165550.GI32263@sortiz-mobl>
References: <1315291948-3188-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315291948-3188-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Sep 05, 2011 at 11:52:28PM -0700, Mark Brown wrote:
> In systems where there is no hardware signal from the processor to the
> PMIC to initiate the final power off sequence we must initiate the
> shutdown with a register write to the PMIC. Support such systems in the
> driver. Since this may prevent a full shutdown of the system platform
> data is used to enable the feature.
Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
