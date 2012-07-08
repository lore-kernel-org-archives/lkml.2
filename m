Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2GHWYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:24:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:26063 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2GHWYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:24:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165496707"
Date: Mon, 9 Jul 2012 00:36:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: arizona: Move digital core supply management to the
 regulator API
Message-ID: <20120708223609.GH15345@sortiz-mobl>
References: <1341428952-5271-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341428952-5271-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jul 04, 2012 at 08:09:12PM +0100, Mark Brown wrote:
> Rather than open coding the enable GPIO control in the MFD core use the
> API to push the management on to the regulator driver. The immediate
> advantage is slight for most systems but this will in future allow device
> configurations where an external regulator is used for DCVDD.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c       |   65 ++++++++++++++++++++------------------
>  include/linux/mfd/arizona/core.h |    1 +
>  2 files changed, 36 insertions(+), 30 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
