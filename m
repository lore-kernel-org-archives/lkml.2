Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2GHWgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:36:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:7787 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab2GHWgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:36:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120116470"
Date: Mon, 9 Jul 2012 00:47:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/6] mfd: arizona: Add more register definitions
Message-ID: <20120708224738.GI15345@sortiz-mobl>
References: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Jul 05, 2012 at 08:35:28PM +0100, Mark Brown wrote:
> These registers will be used in future devices.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/mfd/arizona/registers.h |  163 +++++++++++++++++++++++++++++++++
>  1 file changed, 163 insertions(+)
This patch and the 5 foloowing ones, all applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
