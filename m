Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab2LIPZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:25:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:43894 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758628Ab2LIPZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:25:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,246,1355126400"; 
   d="scan'208";a="229010909"
Date: Sun, 9 Dec 2012 16:25:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: arizona: Disable control interface reporting for
 WM5102 and WM5110
Message-ID: <20121209152539.GD26699@sortiz-mobl>
References: <1354675565-24794-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354675565-24794-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Dec 05, 2012 at 11:46:04AM +0900, Mark Brown wrote:
> Rather than disabling the error reporting only for earlier revisions
> unconditionally disable it.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This is a bug fix for later chip revisons.
> 
>  drivers/mfd/arizona-irq.c |   18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
Applied to my for-linus branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
