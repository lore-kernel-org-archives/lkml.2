Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2KWLTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:19:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:54927 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab2KWLTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:19:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,307,1352102400"; 
   d="scan'208";a="223420890"
Date: Fri, 23 Nov 2012 12:19:43 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/1] Documentation: Fix historical inconsistency in STMPE
 DT doc
Message-ID: <20121123111943.GF12685@sortiz-mobl>
References: <1353587064-10541-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353587064-10541-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Thu, Nov 22, 2012 at 12:24:24PM +0000, Lee Jones wrote:
> Previously a generic binding 'i2c-client-wake' was created which
> enabled I2C devices to register themselves as wake-up devices.
> This binding was later over-thrown by 'wakeup-source'. The STMPE
> driver was fixed-up, but the document was neglected. This patch
> aims to rectify that.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/mfd/stmpe.txt |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
