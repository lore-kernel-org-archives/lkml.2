Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab2EKNLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:11:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:53050 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab2EKNLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:11:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139494566"
Date: Fri, 11 May 2012 15:21:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: AnilKumar Ch <anilkumar@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65217: Staticise non-exported
 tps65217_update_bis()
Message-ID: <20120511132128.GJ1214@sortiz-mobl>
References: <1336594685-20954-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336594685-20954-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, May 09, 2012 at 09:18:05PM +0100, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/tps65217.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
