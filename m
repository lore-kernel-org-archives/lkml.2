Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab1HVPEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:04:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:61699 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1HVPEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:04:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,263,1312182000"; 
   d="scan'208";a="9771708"
Date: Mon, 22 Aug 2011 17:06:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH linux-next] mfd: omap-usb-host: add module.h and export.h
 to fix build break
Message-ID: <20110822150648.GA4607@sortiz-mobl>
References: <1313767445-20033-1-git-send-email-gadiyar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313767445-20033-1-git-send-email-gadiyar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anand,

On Fri, Aug 19, 2011 at 08:54:05PM +0530, Anand Gadiyar wrote:
> linux-next as of 20110817 fails to build if these two headers
> are not included. Including module.h is sufficient for now,
> but add export.h for EXPORT_SYMBOL and THIS_MODULE in advance
> to avoid a later build break.
> 
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
I applied a similar patch (without the +#include <linux/export.h>) from Ming
Lei <tom.leiming@gmail.com>.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
