Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2EKRkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:40:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:13680 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972Ab2EKRkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:40:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165045887"
Date: Fri, 11 May 2012 19:49:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, jedu@slimlogic.co.uk,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH REBASE 4/4] gpio: tps65910: move this as platform driver
Message-ID: <20120511174958.GT1214@sortiz-mobl>
References: <1336753107-20142-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336753107-20142-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Fri, May 11, 2012 at 09:48:27PM +0530, Laxman Dewangan wrote:
> Make the gpio-tps65910 as platform driver and register
> this from tps65910 core driver as mfd sub device.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
