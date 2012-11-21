Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2KUOLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:11:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:43979 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab2KUOLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:11:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208";a="220650859"
Date: Wed, 21 Nov 2012 15:10:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 1/1] mfd/twl6040: Remove duplicate inclusion of
 linux/err.h
Message-ID: <20121121141058.GU18738@sortiz-mobl>
References: <1353390555-25519-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353390555-25519-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Tue, Nov 20, 2012 at 11:19:15AM +0530, Sachin Kamat wrote:
> linux/err.h was included twice.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/twl6040.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
