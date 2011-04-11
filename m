Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1DKT1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:27:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:42327 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab1DKT1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:27:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,192,1301900400"; 
   d="scan'208";a="417347727"
Date: Mon, 11 Apr 2011 21:27:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Keshava Munegowda <keshava_mgowda@ti.com>
Subject: Re: [PATCH] mfd: Fix usbhs_enable error handling
Message-ID: <20110411192741.GA2618@sortiz-mobl>
References: <1301393275.2253.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301393275.2253.7.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Mar 29, 2011 at 06:07:55PM +0800, Axel Lin wrote:
> In the case of missing platform_data we do not hold a spin_lock,
> thus we should not call spin_unlock_irqrestore in the error path.
> 
> Also simplify the error handling by separating the successful path
> from error path. I think this change improves readability.
Patch applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
