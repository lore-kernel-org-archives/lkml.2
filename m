Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1KNAPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:15:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:38935 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab1KNAPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:15:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,503,1315206000"; 
   d="scan'208";a="74335542"
Date: Mon, 14 Nov 2011 01:19:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Convert wm831x core driver to devm_kzalloc()
Message-ID: <20111114001957.GG22218@sortiz-mobl>
References: <1319546861-7620-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319546861-7620-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Oct 25, 2011 at 02:47:40PM +0200, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm831x-core.c |    2 --
>  drivers/mfd/wm831x-i2c.c  |    3 +--
>  drivers/mfd/wm831x-spi.c  |    3 +--
>  3 files changed, 2 insertions(+), 6 deletions(-)
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
