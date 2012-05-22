Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2EVVlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:41:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:27807 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab2EVVlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:41:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155842497"
Date: Tue, 22 May 2012 23:51:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mfd: tps65910: dt: cleanups in device node parsing
Message-ID: <20120522215113.GD10210@sortiz-mobl>
References: <1337373103-23933-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337373103-23933-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Sat, May 19, 2012 at 02:01:40AM +0530, Laxman Dewangan wrote:
> In this patch series organizing the processing of device node locally specific
> to driver.
> - The gpio specific processing is moved to gpio driver.
> - Core will only process the non-subdevices information.
> - Also keep the allocated pointer for device node in to global structure
>   so that sub devices can use this.
> 
> This patch series is generated on-top of Samuel's mfd subsystem tree.
Thanks, all 3 patches applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
