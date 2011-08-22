Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1HVJ2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:28:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:7456 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1HVJ2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:28:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,262,1312182000"; 
   d="scan'208";a="42602736"
Date: Mon, 22 Aug 2011 11:30:03 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Convert WM8400 to regmap API
Message-ID: <20110822093003.GH4607@sortiz-mobl>
References: <1312875269-26565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312875269-26565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Aug 09, 2011 at 04:34:29PM +0900, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This one also depends on regmap stuff in -next.
So I suppose it would make sense for you to carry this one through the regmap
tree:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
