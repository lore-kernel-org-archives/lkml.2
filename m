Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868Ab2I1Wig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:38:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:13778 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964774Ab2I1Wie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 18:38:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,504,1344236400"; 
   d="scan'208";a="199540712"
Date: Sat, 29 Sep 2012 00:38:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65910: Add alarm interrupt of TPS65910 RTC to
 mfd device list
Message-ID: <20120928223832.GO30928@sortiz-mobl>
References: <1348224936-31938-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348224936-31938-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

On Fri, Sep 21, 2012 at 04:25:36PM +0530, Venu Byravarasu wrote:
> Add RTC alarm interrupt details to TPS65910 MFD device list, to support
> RTC alarm events.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  drivers/mfd/tps65910.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
