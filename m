Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2GHWXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:23:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:64263 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab2GHWXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:23:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120114831"
Date: Mon, 9 Jul 2012 00:34:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: wm8994: Use regcache_sync_region() to sync GPIO
 registers on suspend
Message-ID: <20120708223431.GE15345@sortiz-mobl>
References: <1340978140-11572-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340978140-11572-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jun 29, 2012 at 02:55:39PM +0100, Mark Brown wrote:
> Now we have regcache sync region we can use it to do a more efficient
> sync of the pin configuration after we reset the device during suspend.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-core.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
