Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2CPS6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:58:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:53616 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab2CPS6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="118438761"
Date: Fri, 16 Mar 2012 20:06:31 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] mfd: rc5t583: Add support for RICOH PMIC RC5T583
Message-ID: <20120316190631.GP20524@sortiz-mobl>
References: <1330434317-3554-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330434317-3554-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Tue, Feb 28, 2012 at 06:35:17PM +0530, Laxman Dewangan wrote:
> Ricoh power management IC  RC5T583 contains is multi
> functional device having multiple sub devices inside this.
> This device has multiple dcdc/ldo regulators, gpios, interrupt
> controllers, on-key, RTCs, ADCs.
> This device have 4 DCDCs, 8 LDOs, 8 GPIOs, 6 ADCs, 3 RTCs etc.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
