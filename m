Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2CPRrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 13:47:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:24151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab2CPRrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 13:47:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="121738577"
Date: Fri, 16 Mar 2012 18:55:47 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@opensource.wolfsonmicro.com, jedu@slimlogic.co.uk, lrg@ti.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 2/2] mfd: tps65910: Add support for device sleep
Message-ID: <20120316175547.GK20524@sortiz-mobl>
References: <1331126166-3908-1-git-send-email-ldewangan@nvidia.com>
 <1331126166-3908-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331126166-3908-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Wed, Mar 07, 2012 at 06:46:06PM +0530, Laxman Dewangan wrote:
> Adding support for device sleep through the external
> input control signal "SLEEP".
> Changing the SLEEP signal state can switch the device
> into SLEEP and ACTIVE state.
> Also adding sleep configuration for different resources
> so that they should be keep on during sleep state of
> device.

This one doesn't apply against my for-next branch. Could you please rebase it?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
