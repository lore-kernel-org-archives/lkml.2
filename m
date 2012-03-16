Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab2CPRqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 13:46:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:33020 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab2CPRqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 13:46:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140050391"
Date: Fri, 16 Mar 2012 18:53:47 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@opensource.wolfsonmicro.com, jedu@slimlogic.co.uk, lrg@ti.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1 1/2] mfd: tps65910: Use correct variable name for
 regmap config
Message-ID: <20120316175347.GJ20524@sortiz-mobl>
References: <1331126166-3908-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331126166-3908-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Wed, Mar 07, 2012 at 06:46:05PM +0530, Laxman Dewangan wrote:
> This was the copy-paste issue in reg cache support code where
> variable name for regmap config was not really starting from
> the device name, it was starting from some other device name.
> Fixing this so that variable name contains actual device name.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
