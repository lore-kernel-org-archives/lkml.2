Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1GFSbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:31:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:5468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab1GFSbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:31:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,488,1304319600"; 
   d="scan'208";a="23398849"
Date: Wed, 6 Jul 2011 20:31:26 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH 5/6] MFD: twl6040: Remove enum for PLL tracking
Message-ID: <20110706183126.GJ3021@sortiz-mobl>
References: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
 <1309773958-14608-6-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309773958-14608-6-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Jul 04, 2011 at 01:05:57PM +0300, Peter Ujfalusi wrote:
> There is no need to have two different types for
> tracking the selected PLL.
> Use only the defines, when dealing with the PLLs.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
