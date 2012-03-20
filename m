Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658Ab2CTPtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:49:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:28668 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab2CTPtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:49:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="122988311"
Date: Tue, 20 Mar 2012 16:57:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for TPS65090
Message-ID: <20120320155708.GF17818@sortiz-mobl>
References: <1331876419-10478-1-git-send-email-vbyravarasu@nvidia.com>
 <20120316204015.GW20524@sortiz-mobl>
 <D958900912E20642BCBC71664EFECE3E6DD3127A5B@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DD3127A5B@BGMAIL02.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

On Mon, Mar 19, 2012 at 02:08:31PM +0530, Venu Byravarasu wrote:
> Hi Samuel,
> 
> Thanks for your prompt reply.
> 
> > The patch looks good. Could you please provide me with a better description
> > for this device (sub devices, etc...) ?
> 
> TPS65090 is a PMIC offered by TI. It contains:
> 	a. 3 Step-Down Converters:
> 	b. 2 Always On LDO's
> 	c. 7 Current Limited Load Switches
> 
> With this patch adding basic PMIC functionality along with interrupt controller support.
> Once this patch gets merged, will add regulator driver for this device.
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
