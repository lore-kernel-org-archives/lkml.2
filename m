Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2ETNDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:03:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:59172 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab2ETNDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:03:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102104003"
Date: Sun, 20 May 2012 15:13:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Add r_select to lm3533 platform data
Message-ID: <20120520131337.GU12015@sortiz-mobl>
References: <1337365366-14385-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337365366-14385-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Fri, May 18, 2012 at 08:22:45PM +0200, Johan Hovold wrote:
> Add resistor-select parameter to the platform data.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
> 
> Hi Samuel, 
> 
> I believe this one needs to go in through mfd as the iio driver
> destined for staging-next depends on it.
It should go along with the iio driver if there is a build dependency.
No doing so will prevent the tree from being bisectable.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
