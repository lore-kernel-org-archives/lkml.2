Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2ISL22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:28:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:1188 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab2ISL20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:28:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="224008401"
Date: Wed, 19 Sep 2012 13:28:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] mfd: Convert struct i2c_msg initialization to C99 format
Message-ID: <20120919112827.GI8138@sortiz-mobl>
References: <1347896698-20307-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347896698-20307-1-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shubhrajyoti,

On Mon, Sep 17, 2012 at 09:14:58PM +0530, Shubhrajyoti D wrote:
> Convert the struct i2c_msg initialization to C99 format. This makes
> maintaining and editing the code simpler. Also helps once other fields
> like transferred are added in future.
> 
> Thanks to Julia Lawall <julia.lawall@lip6.fr>  for automating the conversion
> 
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---
>  drivers/mfd/88pm860x-i2c.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
