Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab1B1Qjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:39:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:17445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab1B1Qjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:39:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,240,1297065600"; 
   d="scan'208";a="607316195"
Date: Mon, 28 Feb 2011 17:39:28 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: MFD sharing support (v3, full)
Message-ID: <20110228163836.GA5263@sortiz-mobl>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Thu, Feb 17, 2011 at 07:07:07PM -0800, Andres Salomon wrote:
> Here's all of my third attempt at MFD cell sharing.  This includes all
> parts; some of the patches from v2 are being resent without changes.  I
> apologize for the noise, but since I screwed up the threading in the first 
> batch and people were having trouble finding some of the patches, I figured
> I'd resend everything together.  There are some changes in there as well;
> they've been marked in commit messages.
> 
> This whole set does the following things:
>  - make mfd_cell structs always accessible to platform devices
>  - adjust the mfd_cell API to (hopefully) be cleaner, replacing platform_data
> and driver_data with mfd_data
>  - add wrapper functions to access mfd cell and data fields
>  - adjust all mfd clients/drivers to use the new API
>  - add a reference counting wrapper for mfd_cell's enable/disable hooks
>  - add platform device sharing wrappers to allow mfd clients to create
>    new platform devices (at the same time as platform drivers are being
>    registered)
>  - update the cs5535-mfd driver (and clients) to make use of the new
>    sharing code
> 
> This effectively provides the ability for mfd clients to share a single 
> mfd_cell, and provide the framework for mfd-core be handle shared hardware
> resources.
Thanks a lot for that. I applied all patches now. I have some really minor
comment regarding the naming in patch #28, but we can fix that later.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
