Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1LSLMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:12:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:47848 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab1LSLM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:12:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103752741"
Date: Mon, 19 Dec 2011 12:17:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: Mark WM1811 GPIO6 register volatile for later
 revisions
Message-ID: <20111219111702.GC11800@sortiz-mobl>
References: <1322747814-31877-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1322747814-31877-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322747814-31877-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Dec 01, 2011 at 01:56:54PM +0000, Mark Brown wrote:
> For later chip revisions the WM1811 GPIO6 register is always volatile so
> store the device revision when initialising the driver and then check at
> runtime if we're running on a newer device.
This one depends on your regmap branch, so I'll let you push it.
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
