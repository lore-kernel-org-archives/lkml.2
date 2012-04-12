Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198Ab2DLInk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:43:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:7213 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab2DLInh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:43:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129991024"
Date: Thu, 12 Apr 2012 10:52:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH for 3.4] MFD: twl6040: Convert to i2c driver, and
 separate it from twl core
Message-ID: <20120412085220.GA14106@sortiz-mobl>
References: <1333443411-23056-1-git-send-email-peter.ujfalusi@ti.com>
 <4F8678A0.7090600@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8678A0.7090600@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Apr 12, 2012 at 09:39:28AM +0300, Peter Ujfalusi wrote:
> Hi Samuel, Liam, Tony,
> 
> Now rc2 is out, and the the OMAP4 audio is still broken.
> Can you please queue this patch for 3.4?
I'm busy this week, but I'll queue this one up beginning of next week. I have
several MFD fixes pending, so I'll send a pull request before rc4 I hope.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
