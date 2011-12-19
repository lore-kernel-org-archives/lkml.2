Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1LSRvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:51:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:44926 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1LSRvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:51:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97985947"
Date: Mon, 19 Dec 2011 18:55:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>
Subject: Re: [PATCH] mfd: aat2870-core: constify i2c_device_id table
Message-ID: <20111219175548.GW11800@sortiz-mobl>
References: <1324296142.3350.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324296142.3350.7.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Dec 19, 2011 at 08:02:22PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/aat2870-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
