Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2GJIw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:52:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:44453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab2GJIw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:52:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="169721536"
Date: Tue, 10 Jul 2012 11:03:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: arizona: Add support for multiple PDM speaker
 outputs
Message-ID: <20120710090358.GT15345@sortiz-mobl>
References: <1341858795-27504-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341858795-27504-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jul 09, 2012 at 07:33:14PM +0100, Mark Brown wrote:
> The registers have stride 2 so we can write the loop properly now.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c        |    5 ++---
>  include/linux/mfd/arizona/pdata.h |    2 +-
>  2 files changed, 3 insertions(+), 4 deletions(-)
Both patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
