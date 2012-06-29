Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2F2Pa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:30:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:5452 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab2F2Pa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162277344"
Date: Fri, 29 Jun 2012 17:41:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        paul.liu@linaro.org, shawn.guo@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>
Subject: Re: [PATCH RESEND] mfd: anatop: permit adata be NULL when access
 register
Message-ID: <20120629154135.GL22806@sortiz-mobl>
References: <1338774989-4416-1-git-send-email-richard.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338774989-4416-1-git-send-email-richard.zhao@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Mon, Jun 04, 2012 at 09:56:29AM +0800, Richard Zhao wrote:
> From: Richard Zhao <richard.zhao@linaro.org>
> 
> It makes anatop register access easier. Anatop has many misc registers,
> which may not be a specific driver.
> 
> There's only one anatop device for a running system, so we use a global
> variable to store struct anatop.
Even though I understand it's quite unlikely that you'll never get 2 anatop
blocks on the same system, the below patch is not really nice.
Please make your driver support N > 1 instances of your hardware, even though
it's only for the sake of code cleanness.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
