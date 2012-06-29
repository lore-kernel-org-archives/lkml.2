Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2F2PjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:39:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:29455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab2F2Pi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:38:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186647439"
Date: Fri, 29 Jun 2012 17:50:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Subject: Re: [PATCH 1/1] mfd: max8997: Add missing static storage class
 specifier
Message-ID: <20120629155008.GO22806@sortiz-mobl>
References: <1338808147-1862-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338808147-1862-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin

On Mon, Jun 04, 2012 at 04:39:07PM +0530, Sachin Kamat wrote:
> Fixes the following sparse warnings:
> drivers/mfd/max8997.c:209:4: warning: symbol 'max8997_dumpaddr_pmic' was not declared. Should it be static?
> drivers/mfd/max8997.c:334:4: warning: symbol 'max8997_dumpaddr_muic' was not declared. Should it be static?
> drivers/mfd/max8997.c:344:4: warning: symbol 'max8997_dumpaddr_haptic' was not declared. Should it be static?
> drivers/mfd/max8997.c:426:25: warning: symbol 'max8997_pm' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/max8997.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
