Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1CBOey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:34:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:3673 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab1CBOew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:34:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="396353531"
Date: Wed, 2 Mar 2011 15:34:34 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: peter.ujfalusi@nokia.com, tony@atomide.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/2] twl4030_codec cleanup
Message-ID: <20110302143433.GM16181@sortiz-mobl>
References: <1299072246-26402-1-git-send-email-ilkka.koskinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299072246-26402-1-git-send-email-ilkka.koskinen@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilkka,

On Wed, Mar 02, 2011 at 03:24:04PM +0200, Ilkka Koskinen wrote:
> This series of patches removes duplicate audio_mclk fields from
> twl4030_codec driver.
> 
> The patches have been compiled on sound-2.6/for-2.6.39 branch.
> I haven't tested them on any target board though.
I'm fine with the twl.h changes, but I think it would make sense for Tony to
take this patchset. Tony, is that ok with you ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
