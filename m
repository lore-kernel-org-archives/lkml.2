Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2CPTyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:54:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:42532 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab2CPTyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:54:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129863060"
Date: Fri, 16 Mar 2012 21:01:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: linux-kernel@vger.kernel.org, jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gg@slimlogic.co.uk
Subject: Re: [PATCH] mfd: Fix compilation error in TPS65910.h
Message-ID: <20120316200154.GU20524@sortiz-mobl>
References: <1331882917-27960-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331882917-27960-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

On Fri, Mar 16, 2012 at 12:58:37PM +0530, Venu Byravarasu wrote:
> From: Venu Byravarasu <vbyravarasu@nvidia.com>
> 
> Fix compilation error due to including TPS65910.h
Probably too late for 3.3, but I applied this patch anyway.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
